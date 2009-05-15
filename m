Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbZEOA6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbZEOA6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 20:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZEOA6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 20:58:05 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:34465 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbZEOA6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 20:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WWLclRf3nvSat8jgUjzrjnXqPIsPoWi3pmEyHjq4DZn4Cskiht4auu/GXBiuLn7C8N
         vA0eXSGdcE8+njJ2d3GKap6agrcUwpyYKDJsiGFk00qsSZYnil8gxmJOLfdwrBT/J1Lh
         q5C2NHO+56BNLXHEWU+dzty1+DCY4VNazQABg=
MIME-Version: 1.0
In-Reply-To: <4A0B9B0D.6080006@garzik.org>
References: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com>
	 <4A0B858F.3080405@garzik.org>
	 <6C678488C5CEE74F813A4D1948FD2DC7A95E6D38@cosmail02.lsi.com>
	 <4A0B9B0D.6080006@garzik.org>
Date: Thu, 14 May 2009 17:58:03 -0700
Message-ID: <b1bc6a000905141758y20aa7852h8b1012e3da6f8c0f@mail.gmail.com>
Subject: Re: [RFQ] New driver architecture questions
From: adam radford <aradford@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Mukker, Atul" <Atul.Mukker@lsi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Austria, Winston" <Winston.Austria@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 9:16 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Taking drivers/net/e1000e as an
> example,
>
>        hw.h            hardware-specific defines, ~cross-OS
>        82571.c         code specific to 8257x chip family, ~cross-OS

82571.c contains Linux specific code such as:  including Linux
specific header files, calls to msleep().

>        ich8lan.c       code specific to ICH8+ chip family, ~cross-OS

ich8lan.c contains Linux specific code such as:  might_sleep(),
mutex_trylock(), mutex_unlock(), udelay(), msleep(), writel(), readl().

Perhaps this is a bad example?  It seems like the "common layer"
sections that are "cross-OS" shouldn't contain any Linux specific code at all.

-Adam
