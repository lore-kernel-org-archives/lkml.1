Return-Path: <linux-kernel-owner+w=401wt.eu-S933908AbZHEA3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908AbZHEA3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933870AbZHEA2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:28:51 -0400
Received: from n18.bullet.mail.mud.yahoo.com ([68.142.206.145]:27733 "HELO
	n18.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933844AbZHEA2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:28:31 -0400
X-Yahoo-Newman-Id: 112789.67940.bm@omp417.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ejYeXbJrOoJJ7FC3113YvLSXDWdSeBGTJ+B2PdOoX5yFTAr1ZUup+SuPhqc0ucjqsBtoxdgBwYybg32nFXkgg5UH+keN1x64GnXJej9ozNIDpwTNEGH+pWbfb5vD0B3QDpGL5wfaj6KbWKbAGjl/jiwj/RJQFFvYHFz6dnqrcwE=  ;
X-YMail-OSG: .oPBXdcVM1nsxKTl81xSUGIxbcRHFot2wJUentoZy08Zxz268CpGTMdlgqKkI08Jitgnd8CtdtUz8dHjMqR39WtlOZmxM4Zyh_.Yy0A5zj0RiqtjH33k0fav5oAomFhOna2G_D1btKAZIEcnSsj.DOuQiJVjISpMAPp3i9XhmQO0TXLknpMQKuanEfUVZauR8rTHqrTNrjm1urLOjREmYhV7kVXWk7OCZHxEgOengLMs9GEkH303PnI9wz1TE1Valw.45lv_7JVJA0YPtybp62g98dgaVBy8ESemHnnVzPiPiJFw08JnUlFDhEBQQoeny75zKGQ5NUSlI9yipsaa
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: ben@fluff.org
Subject: Re: gpiolib: add names file in gpio chip sysfs.
Date: Tue, 4 Aug 2009 14:02:00 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20090803165536.345974601@fluff.org>
In-Reply-To: <20090803165536.345974601@fluff.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200908041402.00529.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, ben@fluff.org wrote:
> +static ssize_t chip_names_show(struct device *dev,
> +                              struct device_attribute *attr, char *buf)
> +{
> +       const struct gpio_chip*chip = dev_get_drvdata(dev);
> +       char **names = chip->names;
> +       int ptr = 0;
> +       int name;
> +
> +       if (!names)
> +               return -EINVAL;
> +
> +       for (name = 0; name < chip->ngpio && ptr < PAGE_SIZE; name++)
> +               ptr += snprintf(buf + ptr, PAGE_SIZE - ptr,
> +                               "%s\n", names[name] ? names[name] : "");

Surely the actual GPIO number should be there too?

This whole chip->names thing still seems odd to me,
since it's creating a redundant namespace.


> +
> +       return ptr;
> +}
> +DEVICE_ATTR(names, 0444, chip_names_show, NULL);
> +



