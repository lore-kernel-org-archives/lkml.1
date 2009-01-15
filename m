Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbZAOSML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbZAOSML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZAOSLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:11:55 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:46348 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751447AbZAOSLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:11:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=r4b5BUdSpSgo+BhVeFXYzjAXwCzQebKODZiLx9k9TSERB2kMOb5YsqauHLwCiaXn+aFhH/doZagXcIz/EEnvMcHoZFNCq1bhI0eP2sPM5kgQQRrKf6Dm1nLtUM+IuUoHZnOylykQOO2w64LZdpDbOQO/yK+DucwW7UXa+NGEN8Q=  ;
X-YMail-OSG: mLOxy9QVM1lTZ3rG5ienPdrT75kEIgbJ5pY7JgBuaNjF16OWwRoEekWTOb3Dvqy6CMb2PPnFyAjjQgocFUqX98bRiyEOyWLhC6TTZ1m0xthqyQW.N0S31EWtFLQvja7gFFucPlhCtiYu4sRKOWTykARp96bjbGIBnqXSrwRW8qkqD3829rflZcoCiE7TOt27dQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [patch 2.6.29-rc] regulator: add get_status()
Date: Thu, 15 Jan 2009 10:11:51 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>
References: <200811091531.46003.david-b@pacbell.net> <20090115124007.GD2147@sirena.org.uk> <1232023845.4934.368.camel@vega.slimlogic.co.uk>
In-Reply-To: <1232023845.4934.368.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151011.52250.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009, Liam Girdwood wrote:
> 
> > ...this needs kerneldoc adding.
> 
> Please send a separate patch for the kerneldoc as I've already applied.

Appended....

========== CUT HERE
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
 

