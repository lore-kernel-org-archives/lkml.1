Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450Ab0AGMgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab0AGMgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 07:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383Ab0AGMgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 07:36:32 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60414 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab0AGMgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 07:36:32 -0500
MIME-Version: 1.0
In-Reply-To: <6599ad831001061701x72098dacn7a5d916418396e33@mail.gmail.com>
References: <cover.1262186097.git.kirill@shutemov.name>
	 <9411cbdd545e1232c916bfef03a60cf95510016d.1262186098.git.kirill@shutemov.name>
	 <6599ad831001061701x72098dacn7a5d916418396e33@mail.gmail.com>
Date: Thu, 7 Jan 2010 14:36:29 +0200
Message-ID: <cc557aab1001070436w446ef85n55dd2af5e733f55e@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] cgroup: implement eventfd-based generic API for 
	notifications
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Paul Menage <menage@google.com>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 7, 2010 at 3:01 AM, Paul Menage <menage@google.com> wrote:
> On Wed, Dec 30, 2009 at 7:57 AM, Kirill A. Shutemov
> <kirill@shutemov.name> wrote:
>> +
>> +       if (!IS_ERR(efile))
>> +               fput(efile);
>
> While this is OK currently, it's a bit fragile. efile starts as NULL,
> and IS_ERR(NULL) is false. So if we jump to fail: before trying to do
> the eventfd_fget() then we'll try to fput(NULL), which will oops. This
> works because we don't currently jump to fail: until after
> eventfd_fget(), but someone could add an extra setup step between the
> kzalloc() and the eventfd_fget() which could fail.

So we need to use IS_ERR_OR_NULL here instread of IS_ERR, don't we?
