Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbYKYVUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbYKYVUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYKYVUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:20:09 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:53940 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYKYVUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:20:07 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 0/3] adt7470 extra features
To: "Darrick J. Wong" <djwong@us.ibm.com>, Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Date: Tue, 25 Nov 2008 13:20:05 -0800
Message-ID: <20081125212005.22512.14523.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

As I've been promising for a while, here are (I hope) the features needed
to make the adt7470 driver complete:

The first patch fixes a problem where the pwm outputs temporarily drop toward
zero while temperature sensors are being read.  Since the sensor read operation
can take upwards of a second, the most obvious symptoms of this problem are
fairly annoying: fan spins up for a while, fan spins down, fan spins up, fan
spins for a while... so the solution is to reprogram the chip for manual pwm
control while reading the temperature sensors.

The second patch automatically determines the number of temperature sensors
attached to the adt7470 so that we can shorten the sensor update interval as
much as possible.

The third patch creates a kernel thread that continually updates the temp
sensors so that the in-chip automatic control algorithm will run.  Per an
earlier discussion, the adt7470 can determine the correct pwm output on its
own, but it needs to be told to gather temperature data by hand.

--D
