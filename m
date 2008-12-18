Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbYLRWov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbYLRWov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbYLRWoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:44:38 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47129 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbYLRWog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:44:36 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <494AD224.4000200@s5r6.in-berlin.de>
Date: Thu, 18 Dec 2008 23:43:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org, Jay Fenlason <fenlason@redhat.com>
Subject: Re: [PATCH 2/4] firewire: cdev: use an idr rather than a linked list
 for resources
References: <20081124163728.GA5826@redhat.com> <492AEED8.9030102@s5r6.in-berlin.de> <492AEF9D.5010307@s5r6.in-berlin.de> <tkrat.7bf80e1dd5c90f36@s5r6.in-berlin.de> <tkrat.c14b3f03d12b2b29@s5r6.in-berlin.de>
In-Reply-To: <tkrat.c14b3f03d12b2b29@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote on 2008-12-14:
> From: Jay Fenlason <fenlason@redhat.com>
> 
> The current code uses a linked list and a counter for storing
> resources and the corresponding handle numbers.  By changing to an idr
> we can be safe from counter wrap-around giving two resources the same
> handle.
> 
> Furthermore, the deallocation ioctls now check whether the resource to
> be freed is of the intended type.
> 
> Signed-off-by: Jay Fenlason <fenlason@redhat.com>
> 
> Some rework by Stefan R:
>   - The idr API documentation says we get an ID within 0...0x7fffffff.
>     Hence we can rest assured that idr handles fit into cdev handles.
>   - Fix some races.  Add a client->in_shutdown flag for this purpose.
>   - Add allocation retry to add_client_resource().
>   - It is possible to use idr_for_each() in fw_device_op_release().
>   - Small style changes.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Back to the drawing board.  This patch breaks FCP for dvgrab, kino,
gscanbus.

dvgrab:  only works with -guid ...
kino:  shows live preview but can't list nor control camcorder
gscanbus:  segfaults if I click on the camera icon to bring up the info
window with AV/C controls.
-- 
Stefan Richter
-=====-==--- ==-- =--=-
http://arcgraph.de/sr/
