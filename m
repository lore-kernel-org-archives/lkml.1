Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbYHNM2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbYHNM2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 08:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYHNM15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 08:27:57 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:42342 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbYHNM15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 08:27:57 -0400
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4BCB@USILMS12.ca.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       "Arjan van de Ven" <arjan@infradead.org>, hch@infradead.org,
       linux-kernel@vger.kernel.org, linux-kernel-owner@vger.kernel.org,
       malware-list@lists.printk.net, malware-list-bounces@dmesg.printk.net,
       peterz@infradead.org, "Theodore Tso" <tytso@mit.edu>,
       viro@ZenIV.linux.org.uk
Subject: RE: [malware-list] TALPA - a threat model?  well sorta.
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Thu, 14 Aug 2008 13:27:54 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 14/08/2008 13:27:54,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 14/08/2008 13:27:54,
	Serialize complete at 14/08/2008 13:27:54,
	S/MIME Sign failed at 14/08/2008 13:27:54: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 14/08/2008 13:27:55,
	Serialize complete at 14/08/2008 13:27:55
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080814122800.45BA42FE810@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Press wrote on 14/08/2008 13:03:40:

> > Hm, maybe by implementing a facility with which a client can register
> it's
> > interface usage intent? Something like:
> > 
> > register(I_HAVE_NO_INTEREST_IN_CONTENT);
> > register(I_WANT_TO_EXAMINE_CONTENT);
> > 
> > All former ones would run first because they only want to have the
> > opportunity to block and do something unrelated to file content (like
> > HSMs), and later group would be ran last since they want to examine
> the
> > content.
> > 
> > Ordering inside those two groups is not important because I don't see
> how
> > a model other than restrictive can make sense with content security
> > scanning.
> 
> I'm not sure I understand why "interest in content" means not blocking,
> and vice versa.  However, I think this is a good idea if made more
> explicit, i.e.:

Small misunderstanding because both would block. If you go back to Ted's 
original post I was replying to, he was worried about how would 
anti-malware scanning interact with HSM since both may end up using the 
same interface. HSM, as far as I understand it, needs to block on open and 
"plant" the right file in place, while anti-malware also needs to block 
and examine the right content. That is why ordering matters, anti-malware 
needs to run after the content is put in place. And that is what my idea 
solves (slight overstatement since I spent only seconds on it) by 
separating them in two groups of clients. First which has no interest in 
content and second which does.

--
Tvrtko A. Ursulin
Senior Software Engineer, Sophos

"Views and opinions expressed in this email are strictly those of the 
author.
 The contents has not been reviewed or approved by Sophos."
 

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

