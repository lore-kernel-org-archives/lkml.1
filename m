Return-Path: <linux-kernel-owner+w=401wt.eu-S1761055AbZJIOyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761055AbZJIOyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761044AbZJIOyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:54:12 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:48699 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760854AbZJIOyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:54:11 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4ACF4E73.5010606@gmail.com>
Date: Fri, 09 Oct 2009 15:53:39 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091007)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Jean Delvare <khali@linux-fr.org>,
       Rodolfo Giometti <giometti@enneenne.com>,
       "Michele De Candia (VT)" <michele.decandia@valueteam.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] ALS: TSL2550 driver move from i2c/chips
References: <4ACF4AC6.7070802@cam.ac.uk>
In-Reply-To: <4ACF4AC6.7070802@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Friday afternoon moment....

That id element will need to be signed for any errors on idr allocation
to be detected.  Will fix for next version.
>  struct tsl2550_data {
> +	struct device *classdev;
>  	struct i2c_client *client;
>  	struct mutex update_lock;
> +	unsigned int id;
>  
>  	unsigned int power_state : 1;
>  	unsigned int operating_mode : 1;
>   
....
>  
> +	data->id = tsl2550_get_id();
> +	if (data->id < 0) {
> +		err = data->id;
> +		goto exit_kfree;
> +	}
>   

Jonathan
