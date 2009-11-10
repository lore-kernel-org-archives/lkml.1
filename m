Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZKKPCC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZKKPCC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:02:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757149AbZKKPCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:02:01 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59510 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbZKKPCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:02:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Vp5hUT7oMioCRkCqBGj+P4x6svG6jwv6qE1GtAF/V4wtuuEheGrEU7LqnUlOdXyOff
         92aXF4kSduAt/UCKhoGD3cIeNziY740yUstDPfOyUfyjylGC01GMRVgMXmBCpHgD7Mqp
         RFIckS1xXZioJJW7uWl334Oul6WWSpF6/RrK4=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: tabbott@ksplice.com, alan-jenkins@tuffmail.co.uk, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v4 0/2] bsearch: fix overflow and avoid unnecessary calculation
Date: Tue, 10 Nov 2009 13:00:23 -0200
Message-Id: <cover.1257864001.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.153.g6e31f.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a rare overflow situation which can occur when working with large arrays.
Also, remove an unneeded calculation.

changelog:
    v4: fix the overflow which could still happen when the number of array
        elements to search approached the maximum value of size_t and to
        find the key element we would need to traverse the whole binary tree
        (making 'start' idx tend towards 'end' idx), as pointed by review
        feedback from Rusty Russell (thanks!)
    v3: fix the comment/example of patch 02/02 at v2 patch series
    v2: fix a bug introduced into 01/02 of the v1 patch series
    v1: initial submission

André Goddard Rosa (2):
  bsearch: avoid unneeded decrement arithmetic
  bsearch: prevent overflow when computing middle comparison element

 lib/bsearch.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

