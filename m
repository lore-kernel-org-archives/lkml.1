Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZBIV60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZBIV60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZBIV6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:58:15 -0500
Received: from ausxippc101.us.dell.com ([143.166.85.207]:32607 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbZBIV6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:58:14 -0500
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Feb 2009 16:58:13 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C98B00.2EABEB8E"
Subject: [PATCH] libata: change drive ready wait after hard reset to 5s
Date: Mon, 9 Feb 2009 15:48:45 -0600
Message-ID: <DFEF91B22ED07447AB6AA4B237F913F902185A2B@ausx3mpc125.aus.amer.dell.com>
In-Reply-To: <DFEF91B22ED07447AB6AA4B237F913F9021859A8@ausx3mpc125.aus.amer.dell.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] libata: change drive ready wait after hard reset to 5s
Thread-Index: AcmEGMaJ2daiPnxFR5+tDW9ts3O/TQBPnUHQAWowQWA=
References: <1233456951-992-1-git-send-email-tj@kernel.org> <1233456951-992-4-git-send-email-tj@kernel.org> <DFEF91B22ED07447AB6AA4B237F913F9021859A8@ausx3mpc125.aus.amer.dell.com>
From: <Stuart_Hayes@Dell.com>
To: <jeff@garzik.org>, <linux-scsi@vger.kernel.org>,
       <James.Bottomley@HansenPartnership.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       <Mario_Limonciello@Dell.com>
X-OriginalArrivalTime: 09 Feb 2009 21:48:46.0026 (UTC) FILETIME=[2EEC2AA0:01C98B00]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C98B00.2EABEB8E
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


I'm re-sending this patch... I didn't get a response last time I sent
this in a week ago.  (Is there something wrong with it?)  Thanks!  ...
Stuart



This fixes problems during resume with drives that take longer than 1s
to be ready.  The ATA-6 spec appears to allow 5 seconds for a drive to
be ready.

On one affected system, this patch changes "PM: resume devices took..."
message from 17 seconds to 4 seconds, and gets rid of a lot of ugly
timeout/error messages.

Without this patch, the libata code moves on after 1s, tries to send a
soft reset (which the drive doesn't see because it isn't ready) which
also times out, then an IDENTIFY command is sent to the drive which
times out, and finally the error handler will try to send another hard
reset which will finally get things working.

Sorry to send as an attachment, but my mail server will wrap text.


Signed-off-by: Stuart Hayes <stuart_hayes@dell.com>


------_=_NextPart_001_01C98B00.2EABEB8E
Content-Type: application/octet-stream;
	name="sata_wait5s_on_resume.patch"
Content-Transfer-Encoding: base64
Content-Description: sata_wait5s_on_resume.patch
Content-Disposition: attachment;
	filename="sata_wait5s_on_resume.patch"

LS0tIGxpbnV4LTIuNi4yOC4yL2luY2x1ZGUvbGludXgvbGliYXRhLmgub3JpZwkyMDA5LTAxLTI0
IDE4OjQyOjA3LjAwMDAwMDAwMCAtMDYwMAorKysgbGludXgtMi42LjI4LjIvaW5jbHVkZS9saW51
eC9saWJhdGEuaAkyMDA5LTAyLTAyIDEwOjM2OjMwLjAwMDAwMDAwMCAtMDYwMApAQCAtMjcxLDcg
KzI3MSw3IEBAIGVudW0gewogCSAqIGFkdmlzZWQgdG8gd2FpdCBvbmx5IGZvciB0aGUgZm9sbG93
aW5nIGR1cmF0aW9uIGJlZm9yZQogCSAqIGRvaW5nIFNSU1QuCiAJICovCi0JQVRBX1RNT1VUX1BN
UF9TUlNUX1dBSVQJPSAxMDAwLAorCUFUQV9UTU9VVF9QTVBfU1JTVF9XQUlUCT0gNTAwMCwKIAog
CS8qIEFUQSBidXMgc3RhdGVzICovCiAJQlVTX1VOS05PV04JCT0gMCwK

------_=_NextPart_001_01C98B00.2EABEB8E--
