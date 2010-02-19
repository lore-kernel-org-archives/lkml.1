Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0BSHwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 02:52:10 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64281 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab0BSHwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 02:52:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=BUmrH/fdbQnb+SJ+XPS15Bv300WzPXWhkoRwiIGyQixNuo+h+FpKu+zii42Lc97d1B
         mO+4k7d6PqNAobFNB3y2IUdRL0irPbMdg8Qg6K1lZ0Hcq7l6GzJEakk11p4gFAiGXmZ/
         Ogw6jTSfe5NN7YoUPP4fXULiwLUwknGFtnHoQ=
MIME-Version: 1.0
Date: Fri, 19 Feb 2010 00:52:05 -0700
Message-ID: <f9d2a5e11002182352ydb439c5j9684e03e6890257@mail.gmail.com>
Subject: drivers/backlight/lcd.c vs drivers/backlight/backlight.c
From: Russ Dill <russ.dill@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mjg@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When these were initially checked in, they were basically the same,
except one was called backlight, the other lcd, one controlled
brightness, the other contrast.

Over time, they have diverged. backlight has sysfs_notify support,
provides uevent changes, and suspend/resume support. lcd has received
set_mode support.

Having a device that has variable brightness and needs info on video
timings, I'm confused at what to do. It seems other driver writers
chose to register and lcd device and a backlight device. It seems like
there is a lot of unnecessary duplication going on here. Should I
create my driver with both interfaces? Maybe with just use lcd and
pretend contrast is brightness, or maybe use backlight and add
set_mode support.
