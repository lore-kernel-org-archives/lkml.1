Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbYBMJ0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbYBMJ0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932576AbYBMJZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:25:13 -0500
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:51889 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766014AbYBMJZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:25:08 -0500
X-Greylist: delayed 1617 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 04:25:07 EST
To: linux-kernel@vger.kernel.org
Subject: Upgrade to 2.6.24 breaks NFS service
From: Nix <nix@esperi.org.uk>
Emacs: (setq software-quality (/ 1 number-of-authors))
Date: Wed, 13 Feb 2008 08:58:03 +0000
Message-ID: <87lk5pjkro.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-dcc1-Metrics: hades 1182; Body=1 Fuz1=1 Fuz2=1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I upgraded from 2.6.23.10 to 2.6.24.2 yesterday, and found NFS service
failing.

To be specific, all locks were blocking forever, with an endless flood
of

Feb 12 22:53:10 loki notice: kernel: statd: server localhost not responding, timed out
Feb 12 22:53:10 loki notice: kernel: lockd: cannot monitor esperi
Feb 12 22:53:45 loki notice: kernel: statd: server localhost not responding, timed out
Feb 12 22:53:45 loki notice: kernel: lockd: cannot monitor esperi
Feb 12 22:54:20 loki notice: kernel: statd: server localhost not responding, timed out
Feb 12 22:54:20 loki notice: kernel: lockd: cannot monitor esperi
Feb 12 22:54:55 loki notice: kernel: statd: server localhost not responding, timed out
Feb 12 22:54:55 loki notice: kernel: lockd: cannot monitor esperi
Feb 12 22:55:20 esperi notice: kernel: lockd: server loki.wkstn.nix not responding, still trying

(esperi is a UML instance on the same machine, connected via a bridged
TUN/TAP interface: the bridge, and network service to esperi and to the
rest of the local net across that bridge, was fine.)

I'm currently using NFSv3 atop nfs-utils 1.1.0.33-gdd08789, with daemons
being started in the suggested order (portmap, mountd, statd
--no-notify, nfsd). This evening I'm going to try to upgrade to
nfs-utils HEAD and see if this continues.

-- 
`The rest is a tale of post and counter-post.' --- Ian Rawlings
                                                   describes USENET
