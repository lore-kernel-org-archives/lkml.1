Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYLKH22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYLKH22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 02:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYLKH2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 02:28:18 -0500
Received: from smtp-out.google.com ([216.239.45.13]:33019 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYLKH2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 02:28:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=UHOXNR5vnbO5kYBChx2xrb6rakiatJb0Z4wAg9h0QSA85nRfcbOS94xrR0OgX2PiX
	37VHo8utNw3/81Ts1bk6w==
MIME-Version: 1.0
In-Reply-To: <20081211141507.a087f270.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081210233654.563182000@menage.corp.google.com>
	 <20081210234432.407064000@menage.corp.google.com>
	 <20081211141507.a087f270.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 10 Dec 2008 23:28:12 -0800
Message-ID: <6599ad830812102328x52657bffm9864a0f9a4b3d5bd@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/3] CGroups: Add css_tryget()
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 9:15 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> Could you add this ?
> ==
> bool    css_is_removed(struct cgroup_subsys_state *css)
> {
>        return test_bit(CSS_REMOVED, &css->flags);
> }
> ==
> Then, I'll use this instead of memcg->obsolete flag.

I actually had a patch almost ready to send out the nuked memcg->obsolete.

A difference in mine is that I did

#define css_is_removed(__css) test_bit(CSS_REMOVED, &(__css)->css.flags)

so that you can use it on any subsystem state object that contains a
"struct cgroup_subsys_state css;" field, which is currently all of
them I think, without having to add the "->css" every time.

Paul
