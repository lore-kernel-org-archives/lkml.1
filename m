Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbYGVKYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbYGVKYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYGVKYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:24:41 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:23573 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753296AbYGVKYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:24:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oKJb8Hgjo0oAtWbJLz33rfng1jYja5LsNxgMy6KUAjNa1Himl0gbaPU7nT06TcjO0S7XKtuT6B6i9J2daYTSXjw0lPc+vSjuBpOhYzPjwJEg9jxwmNHO8XLlQObKE505TTeBCYSfk5FyESOOe4WvLhVv/CBkTBweCyiUcyBv0Ds=  ;
X-YMail-OSG: ovRmTTYVM1lBY1PSiJQwvjM1w8jyCUJf3TIkjo_.eHaBWfdSVDLB36DBY1B7VWB.9SdOTUZhBj5RDWypv3ygVEpp0n4Kjqa7Cyj967niyebYMMRi8ghoNxzl1Us_OoR_g6w-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.26-rc-mm] gpio: max732x driver
Date: Tue, 22 Jul 2008 03:24:38 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, Eric Miao <eric.y.miao@gmail.com>,
       Jean Delvare <khali@linux-fr.org>, Jack Ren <jack.ren@marvell.com>
References: <200807131918.06377.david-b@pacbell.net> <20080722020542.d180162d.akpm@linux-foundation.org>
In-Reply-To: <20080722020542.d180162d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807220324.38929.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008, Andrew Morton wrote:
> > +     if ((mask & chip->dir_input) == 0) {
> > +             dev_dbg(&chip->client->dev, "%s port %d is output only\n",
> > +                     chip->client->name, off);
> > +             return -EACCES;
> 
> I don't think that EACCES is a suitable error code here.  That's a
> security/permissions sort of thing.  If userspace is requesting this
> driver to do something which the hardware cannot do then probably
> EINVAL is the appropriate return code.

EINVAL is one of the most ambiguous return codes available.  It's
worth avoiding whenever there's *ANY* more meaningful code!  In this
case, the gpio_direction_input() call is good about returning that
fault code only for bogus GPIO numbers.

EACCES is what you should get trying to open a write-only file for
reading, which seems like a very direct analogy.  That argument is
just fine... it's the particular access request which must be denied,
in this case because hardware itself disallows it rather than a bit
in an inode.

- Dave
