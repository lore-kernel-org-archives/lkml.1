Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbYBDWNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbYBDWNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYBDWNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:13:14 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:54933 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYBDWNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:13:13 -0500
To: Roel Kluin <12o3l@tiscali.nl>
Cc: len.brown@intel.com, ibm-acpi@hmh.eng.br,
       ibm-acpi-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [drivers/misc/thinkpad_acpi.c] duplicate test if (level & TP_EC_FAN_FULLSPEED)
X-Message-Flag: Warning: May contain useful information
References: <47A78CBB.2090401@tiscali.nl>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 04 Feb 2008 14:13:09 -0800
In-Reply-To: <47A78CBB.2090401@tiscali.nl> (Roel Kluin's message of "Mon, 04 Feb 2008 23:07:55 +0100")
Message-ID: <ada8x20gykq.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Feb 2008 22:13:09.0858 (UTC) FILETIME=[202DF420:01C8677B]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >                 /* safety net should the EC not support AUTO
 >                  * or FULLSPEED mode bits and just ignore them */
 >                 if (level & TP_EC_FAN_FULLSPEED)
 >                         level |= 7;     /* safety min speed 7 */
 >                 else if (level & TP_EC_FAN_FULLSPEED)
 >                         level |= 4;     /* safety min speed 4 */
 > 
 > Note the duplicate test 'if (level & TP_EC_FAN_FULLSPEED)'. should
 > this be replaced by

Actually I suspect one of the two tests should be against TP_EC_FAN_AUTO
(based on the comment).
