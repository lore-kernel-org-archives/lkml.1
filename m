Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbZBZV2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbZBZV2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZBZV2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:28:46 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:45688 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754604AbZBZV2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:28:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5kKlO98ZRTuUm/iNmilI38zKtBeZWo1FQY+x3HbyRQbWQs6pjzuP+rOqv2/tOcrEjdKQT8ibdJvnnq2GMTva62E8GRaG80bG1rTDIH2+fEmOSraqO92o+GY9HdYAwReF+e75tVAN8eRPFocUhS4U5UvXnCYf00x+FD+LV6b7XWU=  ;
X-YMail-OSG: W6pbEnsVM1nftguSBRk0BiyuJit7KBRE38jw3kfutLSw.X5YNQFXNmG.S9nOAYqVJ83HMl.OG5PL96nrFDFJeeiO99MAVX1MB5NdloAxnPMEKUNTSU6rPHY80w7WiOtyE3oi7BMwxH2q33YF27J6o.qyY_tV2_4JBYIp65E6JeqRcotLPqdvvFpLXNjduSH55d2vrG28Hrs6YeBwCm0m225v5WG_s4ehSfhxpQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [patch 2.6.29-rc6 1/2] regulator: enumerate voltages (v2)
Date: Thu, 26 Feb 2009 13:28:41 -0800
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902261148.36892.david-b@pacbell.net> <1235681638.31223.57.camel@vega.slimlogic.co.uk>
In-Reply-To: <1235681638.31223.57.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902261328.41910.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Liam Girdwood wrote:
> Applied with git-am merge conflicts. It builds ok, can you check against
> your tree.

What were the conflicts -- just offsets?

Your "-next" regulator tree seems to be missing a doc patch
you had asked for, maybe that's an issue.

- Dave

=========== CUT HERE
From: David Brownell <dbrownell@users.sourceforge.net>
Subject: regulator: get_status() grows kerneldoc

Add kerneldoc for the new get_status() message.  Fix the existing
kerneldoc for that struct in two ways:

 (a) Syntax, making sure parameter descriptions immediately
     follow the one-line struct description and that the first
     blank lines is before any more expansive description;
 (b) Presentation for a few points, to highlight the fact that
     the previous "get" methods exist only to report the current
     configuration, not to display actual status.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 include/linux/regulator/driver.h |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -34,26 +34,20 @@ enum regulator_status {
 
 /**
  * struct regulator_ops - regulator operations.
- *
- * This struct describes regulator operations which can be implemented by
- * regulator chip drivers.
- *
- * @enable: Enable the regulator.
- * @disable: Disable the regulator.
+ * @enable: Configure the regulator as enabled.
+ * @disable: Configure the regulator as disabled.
  * @is_enabled: Return 1 if the regulator is enabled, 0 otherwise.
- *
  * @set_voltage: Set the voltage for the regulator within the range specified.
  *               The driver should select the voltage closest to min_uV.
  * @get_voltage: Return the currently configured voltage for the regulator.
- *
  * @set_current_limit: Configure a limit for a current-limited regulator.
- * @get_current_limit: Get the limit for a current-limited regulator.
- *
+ * @get_current_limit: Get the configured limit for a current-limited regulator.
  * @set_mode: Set the operating mode for the regulator.
- * @get_mode: Get the current operating mode for the regulator.
+ * @get_mode: Get the configured operating mode for the regulator.
+ * @get_status: Return actual (not as-configured) status of regulator, as a
+ *	REGULATOR_STATUS value (or negative errno)
  * @get_optimum_mode: Get the most efficient operating mode for the regulator
  *                    when running with the specified parameters.
- *
  * @set_suspend_voltage: Set the voltage for the regulator when the system
  *                       is suspended.
  * @set_suspend_enable: Mark the regulator as enabled when the system is
@@ -62,6 +56,9 @@ enum regulator_status {
  *                       suspended.
  * @set_suspend_mode: Set the operating mode for the regulator when the
  *                    system is suspended.
+ *
+ * This struct describes regulator operations which can be implemented by
+ * regulator chip drivers.
  */
 struct regulator_ops {
 
@@ -86,6 +83,7 @@ struct regulator_ops {
 	/* report regulator status ... most other accessors report
 	 * control inputs, this reports results of combining inputs
 	 * from Linux (and other sources) with the actual load.
+	 * returns REGULATOR_STATUS_* or negative errno.
 	 */
 	int (*get_status)(struct regulator_dev *);
 
