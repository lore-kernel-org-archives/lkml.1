Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbZFDJHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbZFDJHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZFDJG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:06:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755220AbZFDJG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:06:57 -0400
Date: Thu, 4 Jun 2009 02:06:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minkyu Kang <mk7.kang@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       kyungmin.park@samsung.com, Anton Vorontsov <cbou@mail.ru>
Subject: Re: [PATCH v2] add MAX17040 Fuel Gauge driver
Message-Id: <20090604020624.4d39e0a3.akpm@linux-foundation.org>
In-Reply-To: <4A278C08.5000206@samsung.com>
References: <4A278C08.5000206@samsung.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Jun 2009 17:55:36 +0900 Minkyu Kang <mk7.kang@samsung.com> wrote:

> +	INIT_DELAYED_WORK_DEFERRABLE(&chip->work, max17040_work);
> +	schedule_delayed_work(&chip->work, MAX17040_DELAY);
> +
> +	bat_ps.properties = max17040_battery_props;
> +	bat_ps.num_properties = ARRAY_SIZE(max17040_battery_props);
> +
> +	ret = power_supply_register(&client->dev, &bat_ps);
> +	if (ret) {
> +		dev_err(&max17040->client->dev,
> +				"failed: power supply register\n");
> +		cancel_delayed_work(&chip->work);
> +		i2c_set_clientdata(client, NULL);
> +		kfree(chip);
> +		max17040 = NULL;
> +		return -1;
> +	}
> +
> +	return 0;
> +}

Wouldn't it be better to start the delayed_work after the
power_supply_register() has succeeded?

