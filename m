Return-Path: <linux-kernel-owner+w=401wt.eu-S2992434AbXCGSRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992434AbXCGSRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992435AbXCGSRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:17:12 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:20935 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992434AbXCGSRK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:17:10 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
Date: Wed, 7 Mar 2007 19:16:57 +0100
User-Agent: KMail/1.9.1
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Maneesh Soni <maneesh@in.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0703061914030.18144@blonde.wat.veritas.com> <200703071759.29522.oliver@neukum.org> <Pine.LNX.4.64.0703071001020.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703071001020.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703071916.57907.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GPE5pUNaoG1wTinqjVVl1GKJZKNFH/11jSg2To
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 7. März 2007 19:02 schrieb Linus Torvalds:
> 
> On Wed, 7 Mar 2007, Oliver Neukum wrote:
> >
> > The problem also exists with unplugging devices. Drivers get no feedback
> > to tell them when it is safe to free the data structures associated with
> > an attribute.
> 
> So you just pointed to *another* data structure that apparently violates 
> the "you MUST use refcounting" rule.
> 
> What is it with you people? It's really simple. Data structures must be 
> refcounted if you can reach them two different ways.
> 
> If you don't use refcounting, then you'd better make sure that the data 
> can be reached only one way (for example, by *not* exposing it for sysfs).
> 
> It really *is* that simple. Read the CodingStyle rules.

Very well, there seems to be no clean way to avoid that work.

	Regards
		Oliver
