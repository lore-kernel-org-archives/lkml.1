Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbZHMIgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbZHMIgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbZHMIgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:36:18 -0400
Received: from smtpx.philips.com ([168.87.56.21]:53007 "EHLO smtpx.philips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbZHMIgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:36:14 -0400
From: "Zeisel, Michael" <michael.zeisel@philips.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 13 Aug 2009 10:35:54 +0200
Subject: PROBLEM: full speed HID device with payload of 64 bytes
Thread-Topic: PROBLEM: full speed HID device with payload of 64 bytes
Thread-Index: Acob7oWPWs90Fs5sQEyLh3SE+T3WHgAAlfhg
Message-ID: <A3467C2CEA21E3469A3218B394AD2534C3B9CE2C68@NLCLUEXM09.connect1.local>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {C418F4FB-9E93-4489-B3B2-53484A67DDA3}
x-cr-hashedpuzzle: Dayx ERki EYbi FNgt F8C/ F8Ee GOuc GTyE GWuT G2hz HHTb
 HdbJ Hso6 H6mi H92C
 KPcc;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{C418F4FB-9E93-4489-B3B2-53484A67DDA3};bQBpAGMAaABhAGUAbAAuAHoAZQBpAHMAZQBsAEAAcABoAGkAbABpAHAAcwAuAGMAbwBtAA==;Thu,
 13 Aug 2009 08:35:54
 GMT;UABSAE8AQgBMAEUATQA6ACAAZgB1AGwAbAAgAHMAcABlAGUAZAAgAEgASQBEACAAZABlAHYAaQBjAGUAIAB3AGkAdABoACAAcABhAHkAbABvAGEAZAAgAG8AZgAgADYANAAgAGIAeQB0AGUAcwA=
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear ladies and gentlemen,

We have experienced problems connecting HID devices, which have a data payload of 64 bytes with the following LINUX kernel:

2.6.24-24-generic

What we did:

We experienced those problems with one of our devices, the Digital Pocket Memo 3 (DPM), by simply trying to receive button events via the

Cat /dev/usb/hiddev0

Command -> no success. The only difference between this device and older ones (which work on this kernel version) in the USB descriptor is the data payload which is 64 byte.

To narrow down the cause for that behavior we simply took the same device, put in a FW with a low speed device protocol with a data payload of 8 byte and plugged it again to the PC.

Now the button events produced some symbols in the "terminal", which proves that the device was recognized correctly and works.

According to the USB 2.0 specification under

http://www.usb.org/developers/docs/

USB 2.0 specification, Chapter 5.7.4: Interrupt Transfer Bus Access Constraints

A full speed device should support a maximum data payload of 64 bytes (Table 5-7. Full-speed Interrupt Transaction Limits: max.payload 64 bytes x max.transfers 19  = max. 1216bytes/frame)

To us it seems that the current implementation of the HID device support in LINUX just supports the protocol for low speed devices (Table 5-6. Low-speed Interrupt Transaction Limits: max.payload 8 bytes x max.transfers 6  = max. 48bytes/frame)

On Windows OS and Mac OS all our devices work properly.

My question to you now is, if you could reproduce/investigate that behavior and give me a feeling what the cause and the solution for that problem will be?

I think it is a good idea, if you would have a Digital Pocket Memo to experience the described behavior- so to whom I should send that device?

Kind regards,

Michael Zeisel

Michael Zeisel
SW Project Leader
Philips Consumer Lifestyle

Philips Speech Processing
Gutheil-Schoder-Gasse 12
A - 1102, Vienna
Austria
Tel: +43 1 60101 2806
Fax:+43 1 60101 1833
Mobile: +43 (0)664 8131256


The information contained in this message may be confidential and legally protected under applicable law. The message is intended solely for the addressee(s). If you are not the intended recipient, you are hereby notified that any use, forwarding, dissemination, or reproduction of this message is strictly prohibited and may be unlawful. If you are not the intended recipient, please contact the sender by return e-mail and destroy all copies of the original message.
