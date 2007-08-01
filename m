Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbXHAV6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbXHAV6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXHAV5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:57:41 -0400
Received: from stephens.ittc.ku.edu ([129.237.125.220]:58270 "EHLO
	stephens.ittc.ku.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXHAV5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:57:40 -0400
Date: Wed, 1 Aug 2007 16:57:24 -0500
From: nwatkins@ittc.ku.edu
To: mathieu.desnoyers@polymtl.ca
Cc: nwatkins@ittc.ku.edu, linux-kernel@vger.kernel.org
Subject: [patch 0/1] extending low-level markers
Message-ID: <20070801215723.GA10470@ittc.ku.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: quilt/0.46-1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0.2 (stephens.ittc.ku.edu [129.237.125.220]); Wed, 01 Aug 2007 16:57:24 -0500 (CDT)
X-VirusScan: Clean
X-MailScanner-From: nwatkins@ittc.ku.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu

I have been working with your Kernel Markers infrastructure now for some
time and have run into an extendability issue.

Essentially I am failing to find a way to extend the current
__trace_mark macro with site-specific context. That is, I would like the
ability to create different 'types' of instrumentation points by bulding
upon the __trace_mark macro. A consumer of this marker could examine
the type of marker, and attach an appropriate callback function /
private data.

I have included a patch which adds a flavor field to the __trace_mark
macro. This simplified example demonstrates the functionality I'm
looking for:

#define __trace_mark(flavor, name, format, args...)
		<current macro plus the flavor field>

#define marker_flavor_XXX(name, format, args...)
		__trace_mark(XXX, name, format, args)

Here a marker of type XXX is build upon the __trace_mark macro. When a
consumer of type XXX finds markers with the XXX flavor appropriate
registration can take place.

Unless I don't fully understand all the use cases of the markers, I
don't see any other way to do this except to encode the 'type'
information in the name of the marker, and require the consumer to parse
the string to determine the type. Restricting the names of the markers
in this way seems like a bad solution.

Any help and feedback is greatly appreciated.

- Noah

-- 
