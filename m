Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbZDSGcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbZDSGcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 02:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbZDSGb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 02:31:59 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:25676 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbZDSGb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 02:31:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EzYzvW6w76TrPkQzpdBuTOT4iiBaPXZ+Afm+wgjEoCfibWO3aEoNuqTYZlosc5EeYN
         oIGamyKOF+tlYQXKG0D0su3faMvL5NoicAEPBvh8xz/OY+sqpppfbw/najwOhxpMJjFw
         aLZeOadjxfTFFnZ+gELk99Fq14kmFho9rtljc=
Message-ID: <49EAC55B.4030609@gmail.com>
Date: Sun, 19 Apr 2009 00:31:55 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
CC: linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br>
In-Reply-To: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rogério Brito wrote:
> Dear people,
> 
> I have one small question regarding the libata drivers and the 
> interaction with hdparm.
> 
> I am presently using PATA/IDE devices only, but some distributions 
> provide kernels with libata by default (and some defconfigs also use 
> libata even for IDE devices).
> 
> Using the usual IDE drivers, I can use/query various parameters with 
> hdparm, like, for instance, the -m option, the -c option or even 
> disabling DMA. With the libata drivers, this is all that I get:
> 
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> lutz:~# hdparm /dev/sda
> 
> /dev/sda:
>  IO_support    =  0 (default)
>  readonly      =  0 (off)
>  readahead     = 256 (on)
>  geometry      = 48641/255/63, sectors = 781420655, start = 0
> lutz:~# hdparm -c 1 /dev/sda
> 
> /dev/sda:
>  setting 32-bit IO_support flag to 1
>  HDIO_SET_32BIT failed: Invalid argument
>  IO_support    =  0 (default)
> lutz:~# hdparm -m 16 /dev/sda
> 
> /dev/sda:
>  setting multcount to 16
>  HDIO_SET_MULTCOUNT failed: Inappropriate ioctl for device
>  HDIO_GET_MULTCOUNT failed: Inappropriate ioctl for device
> lutz:~#
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> 
> Am I doing something incorrectly? I would like at least to understand 
> what is happening and, if possible, to fine-tune some settings.
> 
> If necessary, please let me know and I will provide any further 
> information that may be needed.

libata doesn't support many of the ioctls used by hdparm to control 
these options. The idea is that the user shouldn't have to mess with 
them. They were more necessary with old IDE in some cases as it could 
sometimes end up with brain-dead settings..

The set 32-bit IO support only recently got added in 2.6.30-rc kernels. 
However, it already defaults to enabled on all controllers where it's 
supported currently.
