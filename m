Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYJVQ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYJVQ3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbYJVQ3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:29:12 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:26898 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbYJVQ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:29:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=iOGPpmQFtSPbi6OrjzjZghetp+NpEcQZUOnfnZts8tRu04I5N7e8NGbWe4Lg9jlusk
         wOhLJ1uSFE65zH7kFR/fIhc5vBp8q6+HlLGSqsDjSSRvHFHKBrY15xXhPqT3uNO72fXh
         IM44QJXf8FmbfITGY2rak1xyqvvLh7kBYrrcI=
Message-ID: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com>
Date: Wed, 22 Oct 2008 18:29:09 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Possible bug in SCSI Kconfig
Cc: sam@ravnborg.org, James.Bottomley@hansenpartnership.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
In kernel 2.6.27.2 - drivers/scsi/Kconfig we have:

config SCSI_WAIT_SCAN
        tristate
        default m
        depends on SCSI
        depends on MODULES

The tristate field is empty. This has the effect that this option is
not visible in menuconfig and so it's always selected. The default is
"m" for all architectures and so this module is always compiled if
SCSI and MODULES are both enabled.

I'm using a patch like this one:

 config SCSI_WAIT_SCAN
-	tristate
+	tristate "Wait until all the async scans are complete"
 	default m
 	depends on SCSI
 	depends on MODULES

to get rid of that module.

Of course, I have no idea if this is correct or the current behavior
is the expected one.

Regards,
Fabio
