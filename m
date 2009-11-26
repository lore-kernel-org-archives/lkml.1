Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbZKZA0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbZKZA0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 19:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759994AbZKZA0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 19:26:12 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:41572 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759662AbZKZA0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 19:26:12 -0500
From: Ian Molton <ian.molton@collabora.co.uk>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, mpm@selenic.com
Subject: 
Date: Thu, 26 Nov 2009 00:25:25 +0000
Message-Id: <1259195127-20086-1-git-send-email-ian.molton@collabora.co.uk>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1259177252.2858.17.camel@calx>
References: <1259177252.2858.17.camel@calx>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset updates the hw_random core to use more efficient buffering.
As an example, the virtio-rng driver is converted to the new API, which fixes
a buffering bug provoked during my work writing a virtio qdev for qemu.

The old API is preserved and all existing drivers should continue to function
without change.

Summary:
 drivers/char/hw_random/core.c       |  120 ++++++++++++++++++++++--------------
 drivers/char/hw_random/virtio-rng.c |   79 ++++++++---------------
 include/linux/hw_random.h           |    9 +-
 3 files changed, 110 insertions(+), 98 deletions(-)

 [PATCH 1/2] hw_random: core updates to allow more efficient drivers
 [PATCH 2/2] virtio: Convert virtio-rng to the new API
