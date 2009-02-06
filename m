Return-Path: <linux-kernel-owner+w=401wt.eu-S1760473AbZBFR7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473AbZBFR7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZBFR7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:59:25 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:25603 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751690AbZBFR7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:59:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wTcTY/qGHRb1suNw3KbYjvfo+yDfC6bZ+ypPQBro4NgUj0l8WpYLbGTQCWtQmfXXYJ82NFrJvDDVxu+di4MUGbUjVX/6J/N290sWcVF3MwdTv/XF9Ue3zXVfBnOxY63RaGiSCo4PqgaZyv4r/XIwdkq+Ws1NehJB8ecQ+/5aEA4=  ;
X-YMail-OSG: FzRf8HAVM1ntuR0qFkMcEEh2yrHr8hl8Do4znX._HlT4F.iF9q3Nwx_cr.RAueCVSxfb3BeKJA3U1v15dzuTLpx8IP11WzAqrb2_1wx77xxruRUmgPuhzaEFwXfLMko69k7c6KyvI1eTdIXxJuADDtONe4xqkIyCX_r2kq19ThsaZkP2lJIqrjhDeoFRkA5uUjUmk7kj95dGUFlVpmWi0iF.6hwmFw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: tom.leiming@gmail.com
Subject: Re: [PATCH] platform driver:fix incorrect use of 'platform_bus_type' with 'struct device_driver'
Date: Fri, 6 Feb 2009 09:59:22 -0800
User-Agent: KMail/1.9.10
Cc: greg@kroah.com, kay.sievers@vrfy.org, LW@karo-electronics.de,
       hmh@hmh.eng.br, linux-kernel@vger.kernel.org
References: <1233934812-20628-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1233934812-20628-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902060959.22413.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 February 2009, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch fixes the bug reported in
>         http://bugzilla.kernel.org/show_bug.cgi?id=11681.
> 
> "Lots of device drivers register a 'struct device_driver' with
> the '.bus' member set to '&platform_bus_type'. This is wrong,
> since the platform_bus functions expect the 'struct device_driver'
> to be wrapped up in a 'struct platform_driver' which provides
> some additional callbacks (like suspend_late, resume_early).
> The effect may be that platform_suspend_late() uses bogus data
> outside the device_driver struct as a pointer pointer to the
> device driver's suspend_late() function or other hard to
> reproduce failures."(Lothar Wassmann)
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

I just glanced at this ... but those parts looked like
good fixes to this family of bugs.  Thanks.

- Dave

