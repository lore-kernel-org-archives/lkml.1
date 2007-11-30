Return-Path: <linux-kernel-owner+w=401wt.eu-S932816AbXK3Kbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbXK3Kbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 05:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbXK3Kbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 05:31:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:6491 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXK3Kbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 05:31:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=k/yU3TpNJfNvDTdGJWQqQ3hdWjKPVbv4MyAOgDM4rx0cGI1EM3VgX47EFauSbucN/rUyj4Yg9GUg67er2froRuOXL69WLFEZOhrXbNaox8lQmYYyVgMRDYZPMYObhFpcVXuQsvs/URvDElqwncQD/Ui0ZW56UTiaX53jo6AsFL4=
Message-ID: <474FE681.9080101@gmail.com>
Date: Fri, 30 Nov 2007 11:31:29 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Chris Rutherford <chrismrutherford@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: ldd irq problem
References: <40dfeece0711291447m2efa4f40i5c2c22a4273ecbc0@mail.gmail.com> <40dfeece0711300128s731b3227xaa0b5982193e4b12@mail.gmail.com>
In-Reply-To: <40dfeece0711300128s731b3227xaa0b5982193e4b12@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2007 10:28 AM, Chris Rutherford wrote:
> Helo lkml,
> 
> I'm trying to write a LDD but I have got a bug.  Any ideas what i
> might be doing wrong?
> 
> ret = request_irq(12, handler, SA_INTERRUPT | SA_SHIRQ, "sha1
> handler", DEVICE_NAME);
> printk (KERN_INFO "req irq %d \n", ret);
> enable_irq(12);

enable_irq is opposite of disable_irq(_nosync), you don't need to call it in
probe function and in most cases you don't need it at all.

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
