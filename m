Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZJUBix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZJUBix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 21:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZJUBiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 21:38:52 -0400
Received: from mail.vyatta.com ([76.74.103.46]:50235 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbZJUBiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 21:38:51 -0400
Date: Wed, 21 Oct 2009 10:38:46 +0900
From: Stephen Hemminger <shemminger@vyatta.com>
To: Nix <nix@esperi.org.uk>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org
Subject: Re: [PATCH] Allow renaming of network interfaces that are up.
Message-ID: <20091021103846.2f985ea1@s6510>
In-Reply-To: <87vdi9ew1h.fsf_-_@spindle.srvr.nix>
References: <87zl7rp1jy.fsf@spindle.srvr.nix>
	<1255723078.14249.16.camel@calx>
	<87k4yup9bd.fsf@spindle.srvr.nix>
	<87vdi9ew1h.fsf_-_@spindle.srvr.nix>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009 19:54:02 +0100
Nix <nix@esperi.org.uk> wrote:

> The ancient restriction banning renaming of busy network interfaces appears
> to be purposeless. Everything that depends on a network interface's name is
> done under the dev_base_lock in any case.
> 
> This makes it much easier to use things like netconsole which bring up a
> network interface before userspace has started: presently these will cause
> interface renamings to fail, breaking any userspace that relies on renaming
> devices to avoid reliance on the potentially-unstable kernel-assigned name.
> 
> Signed-off-by: Nick Alcock <nix@esperi.org.uk>
> ---
>  net/core/dev.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)

This breaks quagga and other applications that track renames.
