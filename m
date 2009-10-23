Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZJWTua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZJWTua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 15:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbZJWTu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 15:50:29 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:35939 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZJWTu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 15:50:28 -0400
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org
Subject: [PATCH] Make it clear how to rename netconsole-used network interfaces.
References: <87zl7rp1jy.fsf@spindle.srvr.nix> <1255723078.14249.16.camel@calx>
	<87k4yup9bd.fsf@spindle.srvr.nix> <87vdi9ew1h.fsf_-_@spindle.srvr.nix>
	<20091021103846.2f985ea1@s6510>
From: Nix <nix@esperi.org.uk>
Emacs: it's all fun and games, until somebody tries to edit a file.
Date: Fri, 23 Oct 2009 20:50:19 +0100
In-Reply-To: <20091021103846.2f985ea1@s6510> (Stephen Hemminger's message of "Wed, 21 Oct 2009 10:38:46 +0900")
Message-ID: <87ljj151qc.fsf_-_@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 Oct 2009, Stephen Hemminger stated:

> On Tue, 20 Oct 2009 19:54:02 +0100
> Nix <nix@esperi.org.uk> wrote:
>> This makes it much easier to use things like netconsole which bring up a
>> network interface before userspace has started: presently these will cause
>> interface renamings to fail, breaking any userspace that relies on renaming
>> devices to avoid reliance on the potentially-unstable kernel-assigned name.
[...]
> This breaks quagga and other applications that track renames.

I've figured out how to do it without patches now. The following doc patch
may help other puzzled users.

---
 Documentation/networking/netconsole.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/networking/netconsole.txt b/Documentation/networking/netconsole.txt
index 8d02207..11c7b90 100644
--- a/Documentation/networking/netconsole.txt
+++ b/Documentation/networking/netconsole.txt
@@ -132,6 +132,13 @@ the sender, it is suggested to try specifying the MAC address of the
 default gateway (you may use /sbin/route -n to find it out) as the
 remote MAC address instead.
 
+TIP: if you need to rename the network interface (as is done by many
+distributions in their startup scripts), you may find that it fails
+for interfaces managed by netconsole, because you cannot rename
+interfaces that are up. The solution here is to take the interface
+down around the renaming, then bring it up again or let the normal
+boot process do so.
+
 NOTE: the network device (eth1 in the above case) can run any kind
 of other network traffic, netconsole is not intrusive. Netconsole
 might cause slight delays in other traffic if the volume of kernel
-- 
1.6.5.1

