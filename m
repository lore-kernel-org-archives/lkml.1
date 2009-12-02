Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbZLBSgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbZLBSgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 13:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbZLBSgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 13:36:48 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:38987 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbZLBSgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 13:36:47 -0500
Message-ID: <4B16B32D.9030106@nortel.com>
Date: Wed, 02 Dec 2009 12:34:21 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: question on type conversions in show_map_vma()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Dec 2009 18:36:51.0355 (UTC) FILETIME=[69EACEB0:01CA737E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another developer and I were looking at show_map_vma() and started
wondering about the "pgoff" value:

pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;

Here we take a variable of type "unsigned long", we cast it to "long
long", shift it, then assign the result to a variable of type "unsigned
long long".

I realize that there isn't any danger of invalid sign extension, but it
does seem a bit odd to be casting to a signed value when the result is
going to be unsigned.

Is there a historical reason why pgoff is unsigned rather than just of
type "loff_t"?

Chris
