Return-Path: <linux-kernel-owner+w=401wt.eu-S1751505AbZHTSi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbZHTSi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 14:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbZHTSi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 14:38:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51345 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZHTSi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 14:38:27 -0400
Date: Thu, 20 Aug 2009 19:38:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anuj Aggarwal <anuj.aggarwal@ti.com>
Cc: lrg@slimlogic.co.uk, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org, felipe.balbi@nokia.com, tony@atomide.com,
       linux-i2c@vger.kernel.org
Message-ID: <20090820183817.GA5032@sirena.org.uk>
References: <1250776230-18245-1-git-send-email-anuj.aggarwal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250776230-18245-1-git-send-email-anuj.aggarwal@ti.com>
X-Cookie: You will inherit millions of dollars.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 2/3] Regulator: Add TPS6507x regulator driver
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 07:20:30PM +0530, Anuj Aggarwal wrote:

One very minor issue:

> +struct tps_pmic {
> +	struct regulator_desc desc[TPS6507X_NUM_REGULATOR];
> +	struct i2c_client *client;
> +	struct regulator_dev *rdev[TPS6507X_NUM_REGULATOR];
> +	struct tps_info *info[TPS6507X_NUM_REGULATOR];

This should be const struct tps_info * since the table of tps_info
structs that this points into is const; otherwise you'll get warnings
from at least sparse.

Otherwise this looks good - I'd be happy to ack this with a followup
patch fixing this issue.
