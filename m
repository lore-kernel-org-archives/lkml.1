Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbZBIQbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbZBIQbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZBIQav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:30:51 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:46803 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbZBIQau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:30:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iYEW3sJ7DXuTgzwiCwZXGlSdhGT6VdfEQEac9U6ReQxA/GlEj1hTKtM5afq5OVDTqR
         71hJvgvecHK5r/g+mo6QVMgjsldYJEDKpDY6rwz3Aah0ItFwLZF5Jahc9VPbOmLfMv94
         Ledc3Bv83D/wwARhs2SnB9OREQufAC2HjauYQ=
MIME-Version: 1.0
Date: Mon, 9 Feb 2009 11:30:47 -0500
Message-ID: <8bd0f97a0902090830y11965ayc436fc1157510764@mail.gmail.com>
Subject: ima changes to shmem breaks !CONFIG_SHMEM
From: Mike Frysinger <vapier.adi@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Serge Hallyn <serue@us.ibm.com>,
       James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 1df9f0a73178718969ae47d813b8e7aab2cf073c broke default building
for Blackfin systems:
  CC      mm/shmem.o
mm/shmem.c: In function 'shmem_zero_setup':
mm/shmem.c:2670: error: implicit declaration of function 'ima_shm_check'
make[1]: *** [mm/shmem.o] Error 1

that's because the ima.h include was added behind the CONFIG_SHMEM
markings rather than everywhere, just like the function is used.
-mike
