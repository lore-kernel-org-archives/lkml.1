Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbYCIRN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbYCIRN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYCIRKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:10:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:60956 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbYCIRKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:10:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=v/JlQ3tAgVCvHFQchr9Hi2TAfaEIKHBFqPPg0FERHOfiP0veXUW1/P6VNwZc9BXDRV3szhSHlDY+FRkruP9UnL5SqsJ2/iQOFD9QokPK/dG/2lQ4F0HaJ3uO3mJQ5hvpHdNXkUZ22upqrCsZuCVkngcr9/AmiKYpXsIXi0E3+y0=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 0/4] ide-tape: remove pipeline functionality-v2
Date: Sun,  9 Mar 2008 18:10:28 +0100
Message-Id: <1205082632-3418-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here are some patches removing the code for adding r/w requests to the pipeline.
Instead, they are being queued straight onto the device request queue now. In
addition, pipeline speed/control calculation has been removed since it becomes
also unused.

 drivers/ide/ide-tape.c |  334 +++++++-----------------------------------------
 1 files changed, 46 insertions(+), 288 deletions(-)
