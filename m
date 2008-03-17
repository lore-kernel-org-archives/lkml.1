Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbYCQB56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbYCQB56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 21:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYCQB5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:57:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:14452 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbYCQB5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:57:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=EmhBFsJ6s84Rzy0f2vWzXDHUpwdaiydg7LhOGqXk0sOECRiLp3pSzKJOr4xFbAiIX
	76xdWJt58HAL2CSHrTzpA==
Message-ID: <6599ad830803161857r6d01f962vfd0f570e6124ab24@mail.gmail.com>
Date: Mon, 17 Mar 2008 09:57:37 +0800
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [RFC][0/3] Virtual address space control for cgroups
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47DDCDA7.4020108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain>
	 <6599ad830803161626q1fcf261bta52933bb5e7a6bdd@mail.gmail.com>
	 <47DDCDA7.4020108@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 9:47 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
>  It will be code duplication to make it a new subsystem,

Would it? Other than the basic cgroup boilerplate, the only real
duplication that I could see would be that there'd need to be an
additional per-mm pointer back to the cgroup. (Which could be avoided
if we added a single per-mm pointer back to the "owning" task, which
would generally be the mm's thread group leader, so that you could go
quickly from an mm to a set of cgroup subsystems).

And the advantage would that you'd be able to more easily pick/choose
which bits of control you use (and pay for).

Paul
