Return-Path: <linux-kernel-owner+w=401wt.eu-S1751794AbZIPDp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbZIPDp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 23:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbZIPDp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 23:45:58 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:36675 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZIPDp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 23:45:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tab3TQsuNFSKT6sXz8r7wjfcfDNb9UzovqS15FEeEvPVCaFM0KD45mJuuu4p84S2+f
         675mLuZRf7AvyTHVbm/gm/MgohZ1kYZSDOMHTrX3kvbcCtQwohJtitwAuEBOjQduKOqL
         IynjcCS5ybfkLFAgAQ6DltOJ8rGgLc77gcOSY=
Date: Tue, 15 Sep 2009 20:45:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Javier Herrero <jherrero@hvsistemas.es>, Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v4] input/keyboard: new OpenCores Keyboard Controller
	driver
Message-ID: <20090916034555.GA2756@core.coreip.homeip.net>
References: <20090915055224.GD1132@core.coreip.homeip.net> <1253066440-25555-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253066440-25555-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Tue, Sep 15, 2009 at 10:00:40PM -0400, Mike Frysinger wrote:
> +
> +static int __devexit opencores_kbd_remove(struct platform_device *pdev)
> +{
> +	struct opencores_kbd *opencores_kbd = platform_get_drvdata(pdev);
> +
> +	free_irq(opencores_kbd->irq, opencores_kbd);
> +
> +	input_unregister_device(opencores_kbd->input);
> +	kfree(opencores_kbd);

You need to do iounmap and free the memory region here as well.
> +
> +	platform_set_drvdata(pdev, NULL);
> +
> +	return 0;
> +}
> +

-- 
Dmitry
