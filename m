Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbYDCSa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbYDCSa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYDCSaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:30:19 -0400
Received: from smtp-out.google.com ([216.239.33.17]:47146 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbYDCSaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:30:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=FDlEUt6NtFX31dwZN9AJUSFtkLy55gq+o/e2uLInOgVEHq06XBHOebb+/4ecq13Qz
	o3NQhoDwEdaGD+fNR2kyQ==
Message-ID: <6599ad830804031130s666368a8v2b31ee6db493b501@mail.gmail.com>
Date: Thu, 3 Apr 2008 11:30:00 -0700
From: "Paul Menage" <menage@google.com>
To: "Dave Hansen" <dave@linux.vnet.ibm.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v7)
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1207247113.21922.63.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403174433.26356.42121.sendpatchset@localhost.localdomain>
	 <1207247113.21922.63.camel@nimitz.home.sr71.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 11:25 AM, Dave Hansen <dave@linux.vnet.ibm.com> wrote:
>  > +     /*
>  > +      * Search through everything else. We should not get
>  > +      * here often
>  > +      */
>  > +     do_each_thread(g, c) {
>  > +             if (c->mm == mm)
>  > +                     goto assign_new_owner;
>  > +     } while_each_thread(g, c);
>
>  What is the case in which we get here?  Threading that's two deep where
>  none of the immeidate siblings or children is still alive?

Probably the most likely case of this would be a LinuxThreads process
where the manager thread exits, and then the main thread, while other
threads still exist.

Paul
