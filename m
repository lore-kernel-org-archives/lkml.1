Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZFWLys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZFWLys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZFWLyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:54:40 -0400
Received: from av12-1-sn2.hy.skanova.net ([81.228.8.185]:44833 "EHLO
	av12-1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbZFWLyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:54:40 -0400
Message-ID: <4A40C280.2010801@mocean-labs.com>
Date: Tue, 23 Jun 2009 13:54:40 +0200
From: =?ISO-8859-15?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: linux-input@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kwangwoo.lee@gmail.com,
       Thierry Reding <thierry.reding@avionic-design.de>,
       Trilok Soni <soni.trilok@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] tsc2007: remove HR timer, make platform callbacks optional
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the HR timer, since it's bad to do synchronous I2C
in the HR timer callback context. The new implementation makes use
of the global workqueue. The work is scheduled every 5ms when polling
rather than 5 us.

Secondly the platform callbacks are only called if supplied. Makes
the driver to fallback on only pressure calculation to decide when
the pen is up. This is not as accurate as having a function to call,
but that's not possible on all hardware configurations.

--Richard
