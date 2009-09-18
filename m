Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbZIRDKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbZIRDKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 23:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZIRDKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 23:10:05 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:64558 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZIRDKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 23:10:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wVUe1Q5VjPoX1PWrlARDZGtBvPP4tQuroTagzOPPBCFU4ZK7og9ICZxpr/SFbYcXuA
         1sTUnidv6gTwq/jrqoQBbk8qgDCq3AblygJ5oF2LSYKCEYTrjd2pms7akBo5+jjxuqm2
         IfrstazmOnd2RdYjgB2cnad6dqENOJyJDjGmk=
MIME-Version: 1.0
In-Reply-To: <31cb94fa0909161712m3343812cw349b4a7233bda126@mail.gmail.com>
References: <31cb94fa0909132225l6cb98739o59d105ef480d1cd2@mail.gmail.com>
	 <200909142301.17936.elendil@planet.nl>
	 <200909161619.33461.elendil@planet.nl>
	 <31cb94fa0909161712m3343812cw349b4a7233bda126@mail.gmail.com>
Date: Fri, 18 Sep 2009 11:10:05 +0800
Message-ID: <31cb94fa0909172010v1af9b528vcad5fefbf75341e9@mail.gmail.com>
Subject: Re: PATCH: ARCH in builddeb
From: Wei Chong Tan <weichong78@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: sam@ravnborg.org, max@stro.at, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frans,

How about this? Hopefully this would work for all arch supported.

Regards,
Tan, Wei Chong.

Subject: [PATCH] update builddeb script to allow ARCH customization
Signed-off-by: Tan, Wei Chong <weichong78@gmail.com>
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 8b357b0..96c3ae9 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -24,7 +24,12 @@ create_package() {
 	chmod -R go-w "$pdir"

 	# Create the package
-	dpkg-gencontrol -isp -p$pname -P"$pdir"
+	if [ -n $ARCH ]
+	then
+		dpkg-architecture -a$ARCH -c "dpkg-gencontrol -isp -p$pname -P\"$pdir\""
+	else
+		dpkg-gencontrol -isp -p$pname -P"$pdir"
+	fi
 	dpkg --build "$pdir" ..
 }
