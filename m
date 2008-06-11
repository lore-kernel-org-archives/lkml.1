Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbYFKA3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbYFKA3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 20:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYFKA3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 20:29:45 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:2792 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbYFKA3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 20:29:45 -0400
Subject: bug in jiffy time comparison macros
From: Ralph Campbell <ralph.campbell@qlogic.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: QLogic
Date: Tue, 10 Jun 2008 17:29:41 -0700
Message-Id: <1213144181.5452.26.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2008 00:29:34.0474 (UTC) FILETIME=[390D7EA0:01C8CB5A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It may just be me :-) but this looks like a bug:
In the current include/linux/jiffies.h:

#define time_before(a,b)        time_after(b,a)

Shouldn't this be:

#define time_before(a,b)        time_after_eq(b,a)

There are a number of similar macros which fail
to change before to after_eq, or before_eq to after,
etc.

