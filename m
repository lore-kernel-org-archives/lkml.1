Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab0CKT7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 14:59:38 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56003 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab0CKT7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 14:59:35 -0500
MIME-Version: 1.0
In-Reply-To: <20100309065753.GA8287@linux-sh.org>
References: <20100309065753.GA8287@linux-sh.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 11 Mar 2010 20:59:18 +0100
Message-ID: <ac3eb2511003111159q84e6cefi43de106c79c0e333@mail.gmail.com>
Subject: Re: [PATCH] driver core: Early dev_name() support.
To: Paul Mundt <lethal@linux-sh.org>
Cc: Greg KH <greg@kroah.com>, Magnus Damm <damm@opensource.se>,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2BJxumE032681

On Tue, Mar 9, 2010 at 07:57, Paul Mundt <lethal@linux-sh.org> wrote:> This implements early init_name construction from the matched name/id> pair following the semantics of the late device/driver match. As a> result, matched IDs (inclusive of requested ones) are preserved when the> handoff from the early platform code happens at kobject initialization> time.
> +                       if (!match->dev.init_name) {> +                               char buf[32];> +> +                               if (match->id != -1)> +                                       snprintf(buf, sizeof(buf), "%s.%d",> +                                                match->name, match->id);> +                               else> +                                       snprintf(buf, sizeof(buf), "%s",> +                                                match->name);> +> +                               match->dev.init_name = kstrdup(buf, GFP_KERNEL);> +                               if (!match->dev.init_name)> +                                       return -ENOMEM;> +                       }
This can be kasprintf() I guess.
>  static inline const char *dev_name(const struct device *dev)>  {> +       /* Use the init name until the kobject becomes available */
This should probably state that it's used for getting names out ofunregistered devices. Otherwise it sounds confusing.
> +       if (dev->init_name)> +               return dev->init_name;> +>        return kobject_name(&dev->kobj);>  }
Thanks,Kay���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
