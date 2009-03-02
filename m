Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbZCBOA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbZCBOA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZCBOAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:00:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43554 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751789AbZCBOAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:00:47 -0500
Date: Mon, 2 Mar 2009 14:00:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: Accelerated touchscreen support for Marvell
	Zylonite
Message-ID: <20090302140044.GA23038@rakim.wolfsonmicro.main>
References: <1236000228-13025-1-git-send-email-broonie@opensource.wolfsonmicro.com> <49ABE2BC.9010401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ABE2BC.9010401@gmail.com>
X-Cookie: byob, v:
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 02:44:28PM +0100, Jiri Slaby wrote:
> On 2.3.2009 14:23, Mark Brown wrote:

>> +static int pressure;
>> +module_param(pressure, int, 1);

> Weird permissions.

Fixed.

>> +	int count = 16;
>> +	schedule_timeout_uninterruptible(1);

> You meant ssleep(1)?

msleep, but yes.  Shows how old the code is - I'll update.

>> +
>> +	while (count<  16) {

> Weird condition.
> + conding style

Hrm.  This appears to have been mangled somewhere in the mail path to 
you - the indentation is normal in my send-mail folder and in the copy I
got back from the list.


>> +	if (tries>  5) {

> Where is tries defined?

Further up the file as a global static.  I've pulled the variables into
the function since it's the only place they're used.

>> +static int wm97xx_acc_startup(struct wm97xx *wm)
>> +{
>> +	int idx = 0;

> No need to initialize.

Fixed.

>> +static void wm97xx_irq_enable(struct wm97xx *wm, int enable)
>> +{
>> +	if (enable)
>> +		enable_irq(wm->pen_irq);
>> +	else
>> +		disable_irq(wm->pen_irq);

> sync?

Could you expand on this, please?
