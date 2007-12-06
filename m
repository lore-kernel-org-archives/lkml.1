Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbXLFSuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbXLFSuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 13:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXLFSt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 13:49:56 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:41082 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947AbXLFStz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 13:49:55 -0500
Date: Thu, 6 Dec 2007 19:44:26 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Holger Hoffstaette <holger@wizards.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Reproducible data corruption with sendfile+vsftp - splice
	regression?
Message-ID: <20071206184426.GA32599@electric-eye.fr.zoreil.com>
References: <pan.2007.11.29.23.42.52.661624@wizards.de> <474FC4D9.3020506@cosmosbay.com> <pan.2007.11.30.09.20.24.737500@wizards.de> <475055EE.9060105@hp.com> <pan.2007.12.02.16.00.03.568000@wizards.de> <pan.2007.12.02.20.49.42.675000@wizards.de> <20071205225429.GA10186@electric-eye.fr.zoreil.com> <pan.2007.12.06.09.28.08.913625@wizards.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2007.12.06.09.28.08.913625@wizards.de>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Holger Hoffstaette <holger@wizards.de> :
[...]
> Maybe turning off sendfile or NAPI just lead to random success - so far it
> really looks like tso on the r8169 is the common cause.

TSO on the r8169 is the magic switch but the regression makes imvho more
sense from a VM pov:

- the corrupted file has the same size as the expected file
- the corrupted file exhibits holes which come as a multiple of 4096 bytes
  (8*4k, 2 places, there may be more)
- the r8169 driver does not know what a page is
- the 8169 hardware has a small 8192 bytes Tx buffer

It would be nice if someone could do a sendfile + vsftp test with TSO on a
different hardware. While I could not reproduce the corruption when simply
downloading a file that I had copied on the server with scp, it triggered
almost immediately after I copied it locally and tried to download the copy.

-- 
Ueimor
