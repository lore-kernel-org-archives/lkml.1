Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbZFQOph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbZFQOph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbZFQOpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:45:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42460 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752566AbZFQOpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:45:08 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: Make virtual consumer a bit more chatty
Date: Wed, 17 Jun 2009 15:45:07 +0100
Message-Id: <1245249907-5240-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245249907-5240-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1245249907-5240-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it easier to read the logs when doing testing.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/virtual.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index 5c1d756..1441107 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -34,6 +34,8 @@ static void update_voltage_constraints(struct device *dev,
 
 	if (data->min_uV && data->max_uV
 	    && data->min_uV <= data->max_uV) {
+		dev_dbg(dev, "Requesting %d-%duV\n",
+			data->min_uV, data->max_uV);
 		ret = regulator_set_voltage(data->regulator,
 					data->min_uV, data->max_uV);
 		if (ret != 0) {
@@ -44,6 +46,7 @@ static void update_voltage_constraints(struct device *dev,
 	}
 
 	if (data->min_uV && data->max_uV && !data->enabled) {
+		dev_dbg(dev, "Enabling regulator\n");
 		ret = regulator_enable(data->regulator);
 		if (ret == 0)
 			data->enabled = 1;
@@ -53,6 +56,7 @@ static void update_voltage_constraints(struct device *dev,
 	}
 
 	if (!(data->min_uV && data->max_uV) && data->enabled) {
+		dev_dbg(dev, "Disabling regulator\n");
 		ret = regulator_disable(data->regulator);
 		if (ret == 0)
 			data->enabled = 0;
@@ -69,6 +73,8 @@ static void update_current_limit_constraints(struct device *dev,
 
 	if (data->max_uA
 	    && data->min_uA <= data->max_uA) {
+		dev_dbg(dev, "Requesting %d-%duA\n",
+			data->min_uA, data->max_uA);
 		ret = regulator_set_current_limit(data->regulator,
 					data->min_uA, data->max_uA);
 		if (ret != 0) {
@@ -80,6 +86,7 @@ static void update_current_limit_constraints(struct device *dev,
 	}
 
 	if (data->max_uA && !data->enabled) {
+		dev_dbg(dev, "Enabling regulator\n");
 		ret = regulator_enable(data->regulator);
 		if (ret == 0)
 			data->enabled = 1;
@@ -89,6 +96,7 @@ static void update_current_limit_constraints(struct device *dev,
 	}
 
 	if (!(data->min_uA && data->max_uA) && data->enabled) {
+		dev_dbg(dev, "Disabling regulator\n");
 		ret = regulator_disable(data->regulator);
 		if (ret == 0)
 			data->enabled = 0;
-- 
1.6.3.1

