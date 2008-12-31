Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbYLaBki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbYLaBki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 20:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYLaBka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 20:40:30 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:31966 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751821AbYLaBk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 20:40:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JRv47Oo8fpPfO7AIhM5b0044WjogxF9go0yf3Gak43SC3RA1pkXTZX2R6GGWnkoIjM2oPFd5qnafpJXUHjyhtEbAPvanC6ZMuejDq6KTbYWysWStcSuPZS550CuosYyrNdlWylN/eyzTbaHMfJbi9HhyMn2QTmEfzcjmUY1vX1s=  ;
X-YMail-OSG: qU5GUbsVM1mY5EsR0qPsmGid9NKxb9EGY2QqfruYcHxK.bGdtHBrmA9Rnm5JeWIPENAjikQWec5baUHIfqUj.SFiOzk2iQvYnrNM7ZN9h.ZkkFZvyXtMiHcvWI63yj16iup3gzeTUb7TvKq0eYkwlRCG
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Sarah Sharp <sarah.a.sharp@intel.com>
Subject: Re: [PATCH] include/linux: Move definitions from usb.h to usb/ch9.h
Date: Tue, 30 Dec 2008 17:40:26 -0800
User-Agent: KMail/1.9.10
Cc: Julia Lawall <julia@diku.dk>, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0812292247300.2265@ask.diku.dk> <20081230233727.GA12819@gamba.jf.intel.com>
In-Reply-To: <20081230233727.GA12819@gamba.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200812301740.26432.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 December 2008, Sarah Sharp wrote:
> I thought the include/linux/usb/ch9.h was supposed to include values that are
> defined in various USB specifications (starting with the protocol "chapter 9"
> from the USB 1.1 bus specification).

And not getting too far from "chapter 9" ... there are
a few things from the "common class spec", and constants
defining classes, but they're needed to interpret a lot
of descriptors.


> The constants (masks) used by these 
> functions aren't part of the standards,

They are too!  Bitfields and the values in those bitfields
are part of the endpoint descriptor definitions.

In protocol specs, data format definitions don't usually
define symbolic accessors for fields, or for individual
message structures.  Those are part of a programming
language/environment binding.

This distinction is a Good Thing ... names used in assembly
might use Hungarian Notation to make up for the complete
lack of type checking; names in C would normally leave
type checking to the compiler; names in LISP would use
embedded "-" instead of embedded "_" or embedded "$" for
separators; and so on.  No single set of names can work
everywhere; and even if it could, it would fight against
coding conventions in many organizations.


> so why move these functions to 
> include/linux/usb/ch9.h?  Was it confusing to find these functions, or do you
> have an overall plan for these changes?

You missed earlier mail on the topic.  The basic issue is
that those symbols can (and should!) be used for peripheral
side support as well as host side support ... which means
they should never have been put into a host-only header.

- Dave

