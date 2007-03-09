Return-Path: <linux-kernel-owner+w=401wt.eu-S1161360AbXCIAli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161360AbXCIAli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161361AbXCIAli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:41:38 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.189]:38826 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161360AbXCIAlh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:41:37 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Fwd: Re: 2.6.21-rc suspend regression: sysfs deadlock
Date: Fri, 9 Mar 2007 01:41:10 +0100
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703090141.11044.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GPE5pUNaoG1wTinqjVVl1GKJZKNFH/1RwARfh8
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To let you hear the verdict.

	Regards
		Oliver

----------  Weitergeleitete Nachricht  ----------

Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
Date: Mittwoch, 7. März 2007 19:02
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hugh Dickins <hugh@veritas.com>, Oliver Neukum <oliver@neukum.name>, Maneesh Soni <maneesh@in.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>, Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org


On Wed, 7 Mar 2007, Oliver Neukum wrote:
>
> The problem also exists with unplugging devices. Drivers get no feedback
> to tell them when it is safe to free the data structures associated with
> an attribute.

So you just pointed to *another* data structure that apparently violates 
the "you MUST use refcounting" rule.

What is it with you people? It's really simple. Data structures must be 
refcounted if you can reach them two different ways.

If you don't use refcounting, then you'd better make sure that the data 
can be reached only one way (for example, by *not* exposing it for sysfs).

It really *is* that simple. Read the CodingStyle rules.

		Linus


-------------------------------------------------------
