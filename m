Return-Path: <linux-kernel-owner+w=401wt.eu-S1752115AbXFNMai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbXFNMai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbXFNMac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:30:32 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60084 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbXFNMab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:30:31 -0400
Date: Thu, 14 Jun 2007 14:30:27 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Islam Amer <pharon@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: USB remote control missing keycodes
In-Reply-To: <1181823597.6136.8.camel@iamer-laptop>
Message-ID: <Pine.LNX.4.64.0706141425180.23280@twin.jikos.cz>
References: <20070611101319.GA14284@DervishD> <466D2DF7.9020709@aladin.ro> 
 <1181563063.19258.11.camel@iamer-laptop>  <Pine.LNX.4.64.0706111656340.23280@twin.jikos.cz>
  <1181743734.6163.1.camel@iamer-laptop>  <Pine.LNX.4.64.0706131654180.23280@twin.jikos.cz>
  <d120d5000706130817v5b9291d4h8653ade63882d2bc@mail.gmail.com> 
 <Pine.LNX.4.64.0706131741420.23280@twin.jikos.cz>  <1181750326.6163.6.camel@iamer-laptop>
  <Pine.LNX.4.64.0706131809530.23280@twin.jikos.cz> <1181823597.6136.8.camel@iamer-laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007, Islam Amer wrote:

> Ok here is everything from dmesg after the point of plugging in the usb 
> IR receiver, which is quite lengthy so as an attachment.

Thanks. Obviously this remote has broken report descriptor -- it generates 
0xfa usage code from Consumer page for the "back" key (not to mention that 
it should rather generate 0x224 for KEY_BACK), but logical maximum for 
coresponding field is set to 0xf9, as far as I can see from the dump you 
provided.

I have met such devices already, we are fixing their report descriptors on 
the fly before they enter the HID parser. I will prepare a patch for you 
to test (probably tomorrow, sorry).

BTW this also means that the support for the BACK key can't currently be 
written in userspace using the setkeycodes() method, because this usage is 
currently just ignored, due to being out of range.

-- 
Jiri Kosina
