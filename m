Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbYAOXsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbYAOXsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:48:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbYAOXrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:47:20 -0500
Received: from gw.goop.org ([64.81.55.164]:39537 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbYAOXrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:47:19 -0500
Message-ID: <478D45FB.9050209@goop.org>
Date: Tue, 15 Jan 2008 15:47:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Abhishek Rai <abhishekrai@google.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.23.13]
References: <200801140811.44191.abhishekrai@google.com>
In-Reply-To: <200801140811.44191.abhishekrai@google.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhishek Rai wrote:
> Hi,
>
> (Sorry for the inconvenience caused due to previous misformatted patch, I've most definitely figured out the problem this time. Thanks Michael, Daniel, and Ingo for your help.)
>
> This patch speeds up e2fsck on Ext3 significantly using a technique called Metaclustering. Metaclustering is being discussed on LKML in some other threads, here is the latest patch against the 2.6.23.13 stable kernel, any help in testing and evaluating this will be greatly appreciated! While I'd direct anyone interested in details of metaclustering to other LKML threads discussing it, I've enclosed a brief description here:
>
> Metaclustering refers to storing indirect blocks in clusters on a per-group basis instead of spreading them out along with the data blocks.

Cool!

Sounds like this should also make unlink of large files faster too, 
which is a much more saleable win.  At Digeo we always had the problem 
that deleting a multi-GB PVR file would thrash the disk to death and 
give everyone else ~0 throughput.

    J
