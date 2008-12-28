Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYL1T0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYL1T0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 14:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbYL1T0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 14:26:08 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:22106 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbYL1T0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 14:26:06 -0500
X-Greylist: delayed 1272 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Dec 2008 14:26:06 EST
X-Spam-Flag: NO
X-Spam-Score: -12.489
Message-ID: <4957CDD2.9040903@tudelft.nl>
Date: Sun, 28 Dec 2008 20:04:50 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.18) Gecko/20081120 Mandriva/2.0.0.18-1mdv2009.1 (2009.1) Thunderbird/2.0.0.18 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH, resend] relatime: Let relatime update atime at least
 once per day
References: <20081228152901.GB13565@srcf.ucam.org>
In-Reply-To: <20081228152901.GB13565@srcf.ucam.org>
Content-Type: multipart/mixed;
 boundary="------------050709070709060700000009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050709070709060700000009
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Matthew Garrett schreef:
> Ensure relatime updates atime at least once per day
>     
> Allow atime to be updated once per day even with relatime. This lets
> utilities like tmpreaper (which delete files based on last access time)
> continue working.
:
Sorry, but I doubt it's a good idea. First, it breaks the simple
semantic of relatime (mtime > atime?), mixing it with a rather arbitrary
constant. Second, and most important, there are lots of workloads which
will be strongly affected by this modification. For instance, running
md5sum daily on the filesystem will cause a write for every file.

I think that to solve the problem for your use case, it's better to use
a different approach such as mounting separately /tmp (with the atime
option).

Eric

--------------050709070709060700000009
Content-Type: text/x-vcard; charset=utf-8;
 name="E_A_B_Piel.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="E_A_B_Piel.vcf"

begin:vcard
fn;quoted-printable:=C3=89ric Piel
n;quoted-printable:Piel;=C3=89ric
org:Technical University of Delft;Software Engineering Research Group
adr:HB 08.080;;Mekelweg 4;Delft;;2628 CD;The Netherlands
email;internet:E.A.B.Piel@tudelft.nl
tel;work:+31 15 278 6338
tel;cell:+31 6 2437 9135
x-mozilla-html:FALSE
url:http://pieleric.free.fr
version:2.1
end:vcard


--------------050709070709060700000009--
