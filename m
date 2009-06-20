Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbZFTIVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbZFTIVv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 04:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbZFTIVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 04:21:21 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:38912 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbZFTIVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 04:21:18 -0400
Date: Sat, 20 Jun 2009 10:21:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Hans J. Koch" <hjk@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/1] HWMON: max6650, fix lock imbalance
Message-ID: <20090620102101.35e92c01@hyperion.delvare>
In-Reply-To: <20090619230252.GB3862@local>
References: <1245446795-1901-1-git-send-email-jirislaby@gmail.com>
	<20090619230252.GB3862@local>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jun 2009 01:02:52 +0200, Hans J. Koch wrote:
> On Fri, Jun 19, 2009 at 11:26:35PM +0200, Jiri Slaby wrote:
> > Add omitted update_lock to one switch/case in set_div.
> 
> Ahem, yes, thanks!
> 
> > 
> > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> Signed-off-by: Hans J. Koch <hjk@linutronix.de>
> 
> > ---
> >  drivers/hwmon/max6650.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
> > index 86142a8..58f66be 100644
> > --- a/drivers/hwmon/max6650.c
> > +++ b/drivers/hwmon/max6650.c
> > @@ -418,6 +418,7 @@ static ssize_t set_div(struct device *dev, struct device_attribute *devattr,
> >  		data->count = 3;
> >  		break;
> >  	default:
> > +		mutex_unlock(&data->update_lock);
> >  		dev_err(&client->dev,
> >  			"illegal value for fan divider (%d)\n", div);
> >  		return -EINVAL;

Applied, thanks.

-- 
Jean Delvare
