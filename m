Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYIXSz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYIXSz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYIXSzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:55:08 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:30871 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752856AbYIXSzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:55:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=b8LXAsdopE/WejSliskGGy1qFdl9F6vPRvMIhtjEzKYOmHOrVXDWRVYVh7u3tU0esQdvcq6PGo1K87u5R2lmWEH+y9DMm0ryDUkby2hV7AaYhQ5xw1m7+0g0GYW9vhzrV/HDb/nUJ9BtCvxGwzJj4r5U3YsI0SEZ/E7UkeSLZ+8=  ;
X-YMail-OSG: wgEPwvcVM1nFgPDjrx8gwSV4PozNpXT4OFcbMUL5jkzywXAKFaaueJVcyICla7L4dWLJ9VXRP.izh_P_3pIFAGVUA_VLxcFIMp6zcsr26I6hp4XvKDCAaWAnUk7O21I1UnE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 2/4] powerpc/qe: new call to revert a gpio to a dedicated function
Date: Wed, 24 Sep 2008 11:54:59 -0700
User-Agent: KMail/1.9.9
Cc: Kumar Gala <galak@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>, Timur Tabi <timur@freescale.com>,
       Li Yang <leoli@freescale.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, linuxppc-dev@ozlabs.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080924000255.GA28054@oksana.dev.rtsoft.ru> <B8BAAB1F-10B5-419D-84A7-F724A7E77F41@kernel.crashing.org> <20080924114231.GA8469@oksana.dev.rtsoft.ru>
In-Reply-To: <20080924114231.GA8469@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809241155.00814.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2008, Anton Vorontsov wrote:
> > what do you mean by dedicated function.. be a bit clearer in the commit 
> > log.
> 
> This term is from the QE spec, I didn't invent anything. ;-)
> 
> "Each pin in the I/O ports can be configured as a general-purpose
> I/O signal or as a dedicated peripheral interface signal. ...many
> dedicated peripheral functions are multiplexed onto the ports."

Which, to me, highlights the point I've made previously:  the
right abstraction for you to work with is "pin", not GPIO.

You need to switch a QE "pin" from one of its roles to the other.

Evil things, like oopsing, will happen if you try to use this call
on a GPIO that's not backed by a QE pin.

