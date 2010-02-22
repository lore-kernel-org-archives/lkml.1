Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab0BVJD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 04:03:57 -0500
Received: from mail-yx0-f196.google.com ([209.85.210.196]:63084 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0BVJDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 04:03:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=nwYvPd7w31tMTtn5nLLO4Z5ezzn1PtdYS3Q2lSUJ8WxRTtWg5Kn7tCcpuphDvez+4B
         mxtpgK/9okYhB3obGMtmVdY/Qtzcxry+Uj2ValiW8GTBoCIeba8s6FdmaCkseGrzTdFE
         FHPdR/2X1n9cVk27Ul/OzIxpDvsJErRsdvAJA=
MIME-Version: 1.0
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 22 Feb 2010 17:03:34 +0800
Message-ID: <3c17e3571002220103v9e6158ehb80ac73eb232f9bd@mail.gmail.com>
Subject: IIO ring buffer
To: jic23@hermes.cam.ac.uk, manuel.stahl@iis.fraunhofer.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,
Now users depend on iio ring
events(IIO_EVENT_CODE_RING_50/75/100_FULL) to read data:
                read_size = fread(&dat, 1, sizeof(struct iio_event_data),
                                  fp_ev);
                switch (dat.id) {
                case IIO_EVENT_CODE_RING_100_FULL:
                        toread = RingLength;
                        break;
                case IIO_EVENT_CODE_RING_75_FULL:
                        toread = RingLength*3/4;
                        break;
                case IIO_EVENT_CODE_RING_50_FULL:
                        toread = RingLength/2;
                        break;
                default:
                        printf("Unexpecteded event code\n");
                        continue;
                }
                read_size = read(fp,
                                 data,
                                 toread*size_from_scanmode(NumVals, scan_ts));
                if (read_size == -EAGAIN) {
                        printf("nothing available \n");
                        continue;
                }
And iio ring access node doesn't support blocking io too.  It seems we
lost to let users read data once ring is not empty. And some users
maybe not care about iio ring events at all, but just want to read
data like a input or audio driver. So how about adding the following
support in iio ring:
1. add NOT EMPTY event in IIO event nodes
2. add blocking io support in read function of IIO access nodes
If you agree with that, I can begin to add these and send you a patch.
And a problem I don't know is what you and other people have changed
to Greg's staging tree, and I am not sure what tree the patch should
be againest.

For long term plan, is it possible for ring common level to handle
more common work to avoid code repeating in different drivers?

Thanks
Barry
