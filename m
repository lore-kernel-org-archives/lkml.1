Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYCCWHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYCCWHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbYCCWHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:07:09 -0500
Received: from submit01.sysedata.no ([195.159.29.244]:44313 "EHLO
	submit01.sysedata.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYCCWHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:07:08 -0500
Message-ID: <47CC7686.5030600@db.org>
Date: Mon, 03 Mar 2008 23:07:02 +0100
From: "Alfred E. Heggestad" <aeh@db.org>
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset
References: <47AB5012.20509@db.org> <20080209191206.GD5139@ucw.cz>
In-Reply-To: <20080209191206.GD5139@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> + Komunikate KIP1000 Keyboard Matrix
>> +
>> +     -> -- 1 -- 2 -- 3  --> GPI pin 4 (0x10)
>> +      |    |    |    |
>> +     <- -- 4 -- 5 -- 6  --> GPI pin 5 (0x20)
>> +      |    |    |    |
>> +     END - 7 -- 8 -- 9  --> GPI pin 6 (0x40)
>> +      |    |    |    |
>> +     OK -- * -- 0 -- #  --> GPI pin 7 (0x80)
>> +      |    |    |    |
>> +
>> +     /|\  /|\  /|\  /|\
>> +      |    |    |    |
>> +GPO
>> +pin:  3    2    1    0
>> +     0x8  0x4  0x2  0x1
>> +
>> + */
>> +static int keymap_kip1000(int scancode)
>> +{
>> +	switch (scancode) {			 /* phone 
>> key:   */
>> +	case 0x82: return KEY_0;		 /*   0   
>> */
>> +	case 0x14: return KEY_1;		 /*   1   
>> */
>> +	case 0x12: return KEY_2;		 /*   2   
>> */
>> +	case 0x11: return KEY_3;		 /*   3   
>> */
>> +	case 0x24: return KEY_4;		 /*   4   
>> */
>> +	case 0x22: return KEY_5;		 /*   5   
>> */
>> +	case 0x21: return KEY_6;		 /*   6   
>> */
>> +	case 0x44: return KEY_7;		 /*   7   
>> */
>> +	case 0x42: return KEY_8;		 /*   8   
>> */
>> +	case 0x41: return KEY_9;		 /*   9   
>> */
>> +	case 0x81: return KEY_LEFTSHIFT | KEY_3 << 8; /*  
>> #          */
> 
> That's a very dirty hack, right?
> 

yeah, that is a dirty hack which we should avoid by defining
a new key called e.g. KEY_KPPOUND for the '#'-key.

the CM109 driver is based on the Yealink driver
(drivers/input/misc/yealink.c) so the same hack exists there..


/alfred
