Return-Path: <linux-kernel-owner+w=401wt.eu-S1761380AbYBSTbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761380AbYBSTbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYBSTaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:30:06 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55859 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760629AbYBSTaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:30:00 -0500
Date: Tue, 19 Feb 2008 21:29:24 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Sterba <dsterba@suse.cz>, jkosina@suse.cz
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: ipwireless_network_packet_received(): inconsequent NULL checking
Message-ID: <20080219192924.GI31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following inconsequent NULL checking in 
drivers/char/pcmcia/ipwireless/network.c:

<--  snip  -->

void ipwireless_network_packet_received(struct ipw_network *network,
                                        unsigned int channel_idx,
                                        unsigned char *data,
                                        unsigned int length)
{
...
                /*
                 * If it's associated with a tty (other than the RAS channel
                 * when we're online), then send the data to that tty. The RAS
                 * channel's data is handled above - it always goes through
                 * ppp_generic.
                 */
                if (tty && channel_idx == IPW_CHANNEL_RAS
                                && (network->ras_control_lines &
                                        IPW_CONTROL_LINE_DCD) != 0
                                && ipwireless_tty_is_modem(tty)) {
...
                /* Otherwise we send it out the tty. */
                else
                        ipwireless_tty_received(tty, data, length);
...

<--  snip  -->

ipwireless_tty_received() dereferences "tty".

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

