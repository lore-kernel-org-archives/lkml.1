Return-Path: <linux-kernel-owner+w=401wt.eu-S932602AbXBPReN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbXBPReN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932579AbXBPReN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:34:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946018AbXBPReM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:34:12 -0500
Message-ID: <45D5EA88.7090300@redhat.com>
Date: Fri, 16 Feb 2007 12:31:52 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Could the k8temp driver be interfering with ACPI?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recently my notebook has started shutting down with
these messages in the logs:

	ACPI: Critical trip point
	Critical temperature reached (128 C), shutting down.

But it didn't seem hot at all to me, so I wrote a script to
cat /proc/acpi/thermal_zone/THRM/temperature once a second
and eventually caught this (but no shutdown):

temperature:             47 C
temperature:             47 C
temperature:             128 C
temperature:             48 C
temperature:             47 C

Google found several people reporting problems like mine
after installing lm-sensors, and when I looked at the list
of loaded modules I found k8temp and hwmon there. Then I
realized my problems had started after installing a 2.6.19
kernel that had the new k8temp driver.

So, could ACPI and the k8temp driver be at odds?
