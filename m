Return-Path: <linux-kernel-owner+w=401wt.eu-S1764938AbYHDUdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764938AbYHDUdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764745AbYHDUcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:32:23 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:20971 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764744AbYHDUcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:32:21 -0400
Date: Mon, 4 Aug 2008 22:10:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: `make oldconfig' no longer updating `.config.old'?
Message-ID: <20080804201040.GA28982@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0808040857340.23329@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808040857340.23329@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 09:02:43AM +0200, Geert Uytterhoeven wrote:
> 	Hi,
> 
> I have the habit of doing `make .config{.old,}' after each config run,
> to see what was changed. But since a few weeks, `make oldconfig' no longer
> seems to update `.config.old'.
> 
> This also breaks the default behavior of `scripts/diffconfig' (`If no
> config files are specified, .config and .config.old are used.').
> 
> Was this change intentional?

.config is with current kconfig updated only if a user visible
symbol changes (or something like that).
I had another similar report where .config was not created if
missing and confi was not changed.

Fix is below and I will commit it soon.

	Sam

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 9fba838..36b5eed 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -596,7 +596,7 @@ int main(int ac, char **av)
 		break;
 	}
 
-	if (conf_get_changed() && conf_write(NULL)) {
+	if (conf_write(NULL)) {
 		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
 		exit(1);
 	}

