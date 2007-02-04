Return-Path: <linux-kernel-owner+w=401wt.eu-S1751914AbXBDCDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbXBDCDG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 21:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbXBDCDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 21:03:06 -0500
Received: from web36702.mail.mud.yahoo.com ([209.191.85.36]:20469 "HELO
	web36702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751914AbXBDCDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 21:03:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=acuoSLbO+ZRW2U2MZl/L5ftMOYN+dy+n99CCICkjt/+kg2YpbR3So2/rnYq8hov+9iaGkjyOdEYc7o6hYeJ5JGWmUCvxNbz86Bmcs7q3d+9HlsPZ75Z0B5mUKTwGoGW+MY/38GmzxSufOl7piYA/xywjmPln6Irkv2z4trhvKJc=;
X-YMail-OSG: QwoiD0QVM1niyrAo0kV87dfABtLOBbjQwjFJE8G_G31UWRd98QfrsD.9oUFYzNpNATsAQ3cLBjAFcd5JfLPJlf89jZta5ZgGSyiXJpYeBE8kL6iZv5xbg5gLBuhiLAJ.9FkeL1BkjLqKeLs-
Date: Sat, 3 Feb 2007 18:03:03 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [RFC] [PATCH] Fix up needless kmap:s
To: Pierre Ossman <drzeus-list@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <45C49444.8020503@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <147773.6460.qm@web36702.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The patch looks ok.

However, due to certain peculiarities with memorystick and xd I have to emulate a scatter-gather
in software. Considering that this particular aspect of implementation is the same for all card
types on this TI chip, it can be shared by tifm_sd driver as well. In this case highmem won't be
needed to be avoided and kmap_atomic will come back (may be).

And, by the way, to what extent pagefault_enable/pagefault_disable calls are needed? They are
present in k(u)map_atomic even for non-highmem pages/architectures.



 
____________________________________________________________________________________
Expecting? Get great news right away with email Auto-Check. 
Try the Yahoo! Mail Beta.
http://advision.webevents.yahoo.com/mailbeta/newmail_tools.html 
