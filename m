Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbYHFORS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbYHFORS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 10:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYHFOQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 10:16:56 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:46566 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757373AbYHFOQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 10:16:54 -0400
In-Reply-To: <20080806064418.6afa0672@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       Rik van Riel <riel@redhat.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access
 scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Wed, 6 Aug 2008 15:16:02 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 15:16:50,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 15:16:50,
	Serialize complete at 06/08/2008 15:16:50,
	S/MIME Sign failed at 06/08/2008 15:16:50: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/08/2008 15:16:04,
	Serialize complete at 06/08/2008 15:16:04
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080806141656.8B44B2FE94A@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote on 06/08/2008 14:44:18:

> On Wed, 6 Aug 2008 08:10:53 -0400
> "Press, Jonathan" <Jonathan.Press@ca.com> wrote:
> 
> > However...  This question about arguing for a flawed security
> > technique is a good one, and in a way it gets to the heart of the
> > philosophy of security.  Scan-on-close is admittedly incomplete as an
> > anti-virus tool. But I don't agree that that make it flawed.   It is
> > part of a repertoire of techniques for preventing malware from
> > residing on a machine.
> 
> this indeed gets to the heart of the problem.
> several of us here are trying to argue that scan-on-close isn't very
> good, BUT that if you do scan-on-change (say with inotify) you do reach
> the same goal but with much better results.
> 
> notice the "but" in there. What I hope will happen is that one or more
> people from the AV side (eg you and tvrtko) will actually read the "but"
> part rather than just dismissing it outright because of not liking your
> solution in the first part of it. Part of the answer could be "nice
> however our goal is <THIS> so it won't work because of <THAT>".
> At least as long as <THIS> isn't "scan on close" because that's not a
> goal, that's a means.
> 
> this kind of thing seems to be indicative of the entire discussion.
> For lkml proposals, both sides need to be willing to accept alternative
> solutions for a problem (I know I am, just need to see why ;-).. and
> explain the WHY and the goal if it's not clear.

Problems with inotify as far as I know:

You can't do something like inotify("/") (made up API) but you have to set 
up a watch for every directory you wan't to watch. That seems like a waste 
of resources.

Then you get back a file name, if you wan't to report it or attempt* to 
scan it you have to build a pathname yourself, which means you have to 
maintain the whole tree of names in memory. Even bigger waste.

When I say attempt to scan it above I mean that we are back into the 
pathanme teritorry. It is not guaranteed we will be able to open and scan 
using that pathname. I don't know what inotify reports with chroots and 
private namespaces, but it can certainly fail with NFS and root_squash. So 
it is less effective as well as being resource intensive.

I think this is a good amount of flaws which shows inotify isn't really 
ideal.

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

