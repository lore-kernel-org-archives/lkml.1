Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbYJMUXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbYJMUXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758749AbYJMUWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:22:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:21343 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701AbYJMUWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jk78i6i7sQo5PqMWQuOquY6XpaBpDWEdqTn5ewtg1rMCx0PA265ThL1TjIqYXbv+az
         RGBHOF5EIH8cejMLS7v8glBBmP5Nyb37KspbvK6JDI0VPLSuOFGt7XBTLe8D0eT45zr7
         1fCTP45BxtQXsAxqjFsUeGLydUD0XG9XMvkok=
Message-ID: <9bd6b5360810131322k3d9a6f04h6abcfa6fcd8052f5@mail.gmail.com>
Date: Tue, 14 Oct 2008 04:22:48 +0800
From: sniper <s3c24xx@gmail.com>
To: "Neshama Parhoti" <pneshama@gmail.com>
Subject: Re: section mismatch with a platform driver
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, "Adrian Bunk" <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <912ec82a0810131158o316201a5o803cb46c67c1b065@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <912ec82a0810130119g795c91ffr1083d7e8459a6db1@mail.gmail.com>
	 <20081013085111.GB29938@cs181140183.pp.htv.fi>
	 <912ec82a0810130228m3e9e11bcyfcabe1ab46fb0b6b@mail.gmail.com>
	 <20081013090133.a58116a2.randy.dunlap@oracle.com>
	 <912ec82a0810130929h42574fav985e922ad019b8f5@mail.gmail.com>
	 <48F377F4.7070502@oracle.com>
	 <912ec82a0810131158o316201a5o803cb46c67c1b065@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some examples in kernel as following:

static struct platform_driver my_platform_driver = {
       .probe          = my_probe_func,
       .remove         = __devexit_p(my_remove),
       .suspend        = my_suspend,
       .resume         = my_resume,
       .driver         = {
               .name = DRIVER_NAME,
       },
};


static int __devinit my_probe_func(struct platform_device *pdev)
{
       return 0;
}

note that my_platform_*driver*, it let this variable can refer to
init/exit sections.
You can find the explanation in /scripts/mod/modpost.c:

/* symbols in .data that may refer to init/exit sections */
static const char *symbol_white_list[] =
{
	"*driver",
	"*_template", /* scsi uses *_template a lot */
	"*_timer",    /* arm uses ops structures named _timer a lot */
	"*_sht",      /* scsi also used *_sht to some extent */
	"*_ops",
	"*_probe",
	"*_probe_one",
	"*_console",
	NULL
};


On Tue, Oct 14, 2008 at 2:58 AM, Neshama Parhoti <pneshama@gmail.com> wrote:
> On Mon, Oct 13, 2008 at 6:31 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> Does that mean that all drivers with __init in their probe functions are bogus ?
>>
>> It depends.  If your platform doesn't support hotplug, then it's possible
>> that the probe function is only called during system init, so it would be OK.
>
> Hmm any idea then why did it give me a section mismatch warning ?
>
> Thanks!!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
