Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab0BCDlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:41:53 -0500
Received: from leo.clearchain.com ([199.73.29.74]:31384 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab0BCDlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:41:50 -0500
Date: Wed, 3 Feb 2010 13:39:14 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for eGalax Touchcontroller
Message-ID: <20100203033914.GA23850@barra.bne.redhat.com>
References: <20100202034040.GA16880@barra.bne.redhat.com>
 <alpine.LNX.2.00.1002022129380.15395@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1002022129380.15395@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Wed, 03 Feb 2010 14:11:46 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 02, 2010 at 10:44:35PM +0100, Jiri Kosina wrote:
> On Tue, 2 Feb 2010, Peter Hutterer wrote:
> 
> > Nonetheless, I'm not sure about whether that's the right thing to do. With
> > this patch applied, it gives me two devices, one mute, the other one
> > announces BTN_PEN and BTN_TOUCH + abs axes, though only BTN_TOUCH is ever
> > triggered. Loading usbtouchscreen instead of usbhid for this device makes
> > the device look more sane BTN_TOUCH + abs axes but the actual data is
> > random. So I'm not quite sure what the fix is supposed to be, any hints are
> > appreciated if it's not the patch below.
> 
> The data could also be mis-interpreted because of some bug in the HID 
> descriptor.
> 
> Does looking at the HID report descriptor and looking at the actual 
> raw HID reports coming out from the device give any clue? (in recent 
> kernels, you can just use 'hid' directory in debugfs to gather all this 
> information).

Thanks. The hid descriptor table is attached, but tbh I'm not well-versed
enough in the HID protocol to even tell what format I can give you. I've
attached a simple hexdump of two presses, one with a finger, one with the
stylus. Let me know what format you need or what how I can start to decypher
this myself (are there any parsing tools around?).
 
Cheers,
  Peter

--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="events.hexdump"

0000000 720a 7065 726f 2074 7328 7a69 2065 2936
0000010 2820 756e 626d 7265 6465 0a29 7200 7065
0000020 726f 2074 2032 7328 7a69 2065 2936 3d20
0000030 0020 3020 0032 3020 0033 6120 0030 3020
0000040 0031 3120 0033 3020 0032 000a 6944 6967
0000050 6974 657a 7372 542e 7069 7753 7469 6863
0000060 3d20 3120 000a 6944 6967 6974 657a 7372
0000070 492e 526e 6e61 6567 3d20 3120 000a 6547
0000080 656e 6972 4463 7365 746b 706f 582e 3d20
0000090 3420 3631 000a 6547 656e 6972 4463 7365
00000a0 746b 706f 592e 3d20 3520 3133 000a 720a
00000b0 7065 726f 2074 7328 7a69 2065 2936 2820
00000c0 756e 626d 7265 6465 0a29 7200 7065 726f
00000d0 2074 2032 7328 7a69 2065 2936 3d20 0020
00000e0 3020 0032 3020 0033 6120 0030 3020 0031
00000f0 3120 0032 3020 0032 000a 6944 6967 6974
0000100 657a 7372 542e 7069 7753 7469 6863 3d20
0000110 3120 000a 6944 6967 6974 657a 7372 492e
0000120 526e 6e61 6567 3d20 3120 000a 6547 656e
0000130 6972 4463 7365 746b 706f 582e 3d20 3420
0000140 3631 000a 6547 656e 6972 4463 7365 746b
0000150 706f 592e 3d20 3520 3033 000a 720a 7065
0000160 726f 2074 7328 7a69 2065 2936 2820 756e
0000170 626d 7265 6465 0a29 7200 7065 726f 2074
0000180 2032 7328 7a69 2065 2936 3d20 0020 3020
0000190 0032 3020 0033 6120 0030 3020 0031 3120
00001a0 0030 3020 0032 000a 6944 6967 6974 657a
00001b0 7372 542e 7069 7753 7469 6863 3d20 3120
00001c0 000a 6944 6967 6974 657a 7372 492e 526e
00001d0 6e61 6567 3d20 3120 000a 6547 656e 6972
00001e0 4463 7365 746b 706f 582e 3d20 3420 3631
00001f0 000a 6547 656e 6972 4463 7365 746b 006f
0000200 2e70 2059 203d 3235 0a38 0a00 6572 6f70
0000210 7472 2820 6973 657a 3620 2029 6e28 6d75
0000220 6562 6572 2964 000a 6572 6f70 7472 3220
0000230 2820 6973 657a 3620 2029 203d 2000 3230
0000240 2000 3330 2000 6639 2000 3130 2000 6530
0000250 2000 3230 0a00 4400 6769 7469 7a69 7265
0000260 2e73 6954 5370 6977 6374 2068 203d 0a31
0000270 4400 6769 7469 7a69 7265 2e73 6e49 6152
0000280 676e 2065 203d 0a31 4700 6e65 7265 6369
0000290 6544 6b73 6f74 2e70 2058 203d 3134 0a35
00002a0 4700 6e65 7265 6369 6544 6b73 6f74 2e70
00002b0 2059 203d 3235 0a36 0a00 6572 6f70 7472
00002c0 2820 6973 657a 3620 2029 6e28 6d75 6562
00002d0 6572 2964 000a 6572 6f70 7472 3220 2820
00002e0 6973 657a 3620 2029 203d 2000 3230 2000
00002f0 3330 2000 3161 2000 3130 2000 6430 2000
0000300 3230 0a00 4400 6769 7469 7a69 7265 2e73
0000310 6954 5370 6977 6374 2068 203d 0a31 4400
0000320 6769 7469 7a69 7265 2e73 6e49 6152 676e
0000330 2065 203d 0a31 4700 6e65 7265 6369 6544
0000340 6b73 6f74 2e70 2058 203d 3134 0a37 4700
0000350 6e65 7265 6369 6544 6b73 6f74 2e70 2059
0000360 203d 3235 0a35 0a00 6572 6f70 7472 2820
0000370 6973 657a 3620 2029 6e28 6d75 6562 6572
0000380 2964 000a 6572 6f70 7472 3220 2820 6973
0000390 657a 3620 2029 203d 2000 3230 2000 3330
00003a0 2000 3161 2000 3130 2000 6330 2000 3230
00003b0 0a00 4400 6769 7469 7a69 7265 2e73 6954
00003c0 5370 6977 6374 2068 203d 0a31 4400 6769
00003d0 7469 7a69 7265 2e73 6e49 6152 676e 2065
00003e0 203d 0a31 4700 6e65 7265 6369 6544 6b73
00003f0 6f74 2e70 2058 203d 3134 0a37 4700 0065
0000400 656e 6972 4463 7365 746b 706f 592e 3d20
0000410 3520 3432 000a 720a 7065 726f 2074 7328
0000420 7a69 2065 2936 2820 756e 626d 7265 6465
0000430 0a29 7200 7065 726f 2074 2032 7328 7a69
0000440 2065 2936 3d20 0020 3020 0032 3020 0033
0000450 6120 0031 3020 0031 3020 0062 3020 0032
0000460 000a 6944 6967 6974 657a 7372 542e 7069
0000470 7753 7469 6863 3d20 3120 000a 6944 6967
0000480 6974 657a 7372 492e 526e 6e61 6567 3d20
0000490 3120 000a 6547 656e 6972 4463 7365 746b
00004a0 706f 582e 3d20 3420 3731 000a 6547 656e
00004b0 6972 4463 7365 746b 706f 592e 3d20 3520
00004c0 3332 000a 720a 7065 726f 2074 7328 7a69
00004d0 2065 2936 2820 756e 626d 7265 6465 0a29
00004e0 7200 7065 726f 2074 2032 7328 7a69 2065
00004f0 2936 3d20 0020 3020 0032 3020 0033 6120
0000500 0030 3020 0031 3020 0064 3020 0032 000a
0000510 6944 6967 6974 657a 7372 542e 7069 7753
0000520 7469 6863 3d20 3120 000a 6944 6967 6974
0000530 657a 7372 492e 526e 6e61 6567 3d20 3120
0000540 000a 6547 656e 6972 4463 7365 746b 706f
0000550 582e 3d2
--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=eGalax-hid-descriptor

05 01 09 01 a1 01 85 01 09 01 a1 00 05 09 19 01 29 02 15 00 25 01 95 02 75 01 81 02 95 01 75 06 81 01 05 01 09 30 09 31 16 2a 00 26 bd 07 36 00 00 46 ff 0f 66 00 00 75 10 95 02 81 02 c0 c0 05 0d 09 04 a1 01 85 02 09 20 a1 00 09 42 09 32 15 00 25 01 95 02 75 01 81 02 95 06 75 01 81 03 05 01 09 30 75 10 95 01 a4 55 00 65 00 36 00 00 46 00 00 16 1e 00 26 c8 0f 81 02 09 31 16 3c 00 26 c3 0f 36 00 00 46 00 00 81 02 b4 c0 c0 

  INPUT(1)[INPUT]
    Field(0)
      Physical(GenericDesktop.Pointer)
      Usage(2)
        Button.0001
        Button.0002
      Logical Minimum(0)
      Logical Maximum(1)
      Report Size(1)
      Report Count(2)
      Report Offset(0)
      Flags( Variable Absolute )
    Field(1)
      Physical(GenericDesktop.Pointer)
      Usage(2)
        GenericDesktop.X
        GenericDesktop.Y
      Logical Minimum(42)
      Logical Maximum(1981)
      Physical Minimum(0)
      Physical Maximum(4095)
      Report Size(16)
      Report Count(2)
      Report Offset(8)
      Flags( Variable Absolute )
  INPUT(2)[INPUT]
    Field(0)
      Physical(Digitizers.Stylus)
      Usage(2)
        Digitizers.TipSwitch
        Digitizers.InRange
      Logical Minimum(0)
      Logical Maximum(1)
      Physical Minimum(0)
      Physical Maximum(4095)
      Report Size(1)
      Report Count(2)
      Report Offset(0)
      Flags( Variable Absolute )
    Field(1)
      Physical(Digitizers.Stylus)
      Usage(1)
        GenericDesktop.X
      Logical Minimum(30)
      Logical Maximum(4040)
      Report Size(16)
      Report Count(1)
      Report Offset(8)
      Flags( Variable Absolute )
    Field(2)
      Physical(Digitizers.Stylus)
      Usage(1)
        GenericDesktop.Y
      Logical Minimum(60)
      Logical Maximum(4035)
      Report Size(16)
      Report Count(1)
      Report Offset(24)
      Flags( Variable Absolute )

Button.0001 ---> Key.LeftBtn
Button.0002 ---> Key.RightBtn
GenericDesktop.X ---> Absolute.X
GenericDesktop.Y ---> Absolute.Y
Digitizers.TipSwitch ---> Key.Touch
Digitizers.InRange ---> Key.ToolPen
GenericDesktop.X ---> Absolute.X
GenericDesktop.Y ---> Absolute.Y

--envbJBWh7q8WU6mo--
