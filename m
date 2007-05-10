Return-Path: <linux-kernel-owner+w=401wt.eu-S1762449AbXEJVEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762449AbXEJVEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761925AbXEJVEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:04:39 -0400
Received: from S01060016b61d1226.cg.shawcable.net ([68.147.67.118]:40422 "EHLO
	sandbox.secretlab.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762358AbXEJVEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:04:37 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/2] Eliminate references to new_client in i2c documentation
To: Jean Delvare <khali@linux-fr.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Date: Thu, 10 May 2007 15:04:16 -0600
Message-ID: <20070510210409.11678.5134.stgit@trillian.secretlab.ca>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The use of 'new_client' in i2c device allocation has been refered to as
a 'disease'.  Replace all occurances of 'struct i2c_client *new_client'
in documentation examples with 'struct i2c_client *client'.

Also remove unnecessary zero initializtion of .flags since kzalloc is used.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 Documentation/i2c/writing-clients |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/Documentation/i2c/writing-clients b/Documentation/i2c/writing-clients
index fbcff96..bd61480 100644
--- a/Documentation/i2c/writing-clients
+++ b/Documentation/i2c/writing-clients
@@ -260,7 +260,7 @@ For now, you can ignore the `flags' parameter. It is there for future use.
   {
     int err = 0;
     int i;
-    struct i2c_client *new_client;
+    struct i2c_client *client;
     struct foo_data *data;
     const char *client_name = ""; /* For non-`sensors' drivers, put the real
                                      name here! */
@@ -323,13 +323,12 @@ For now, you can ignore the `flags' parameter. It is there for future use.
       goto ERROR0;
     }
 
-    new_client = &data->client;
-    i2c_set_clientdata(new_client, data);
+    client = &data->client;
+    i2c_set_clientdata(client, data);
 
-    new_client->addr = address;
-    new_client->adapter = adapter;
-    new_client->driver = &foo_driver;
-    new_client->flags = 0;
+    client->addr = address;
+    client->adapter = adapter;
+    client->driver = &foo_driver;
 
     /* Now, we do the remaining detection. If no `force' parameter is used. */
 
@@ -337,7 +336,7 @@ For now, you can ignore the `flags' parameter. It is there for future use.
        parameter was used. */
     if (kind < 0) {
       /* The below is of course bogus */
-      if (foo_read(new_client,FOO_REG_GENERIC) != FOO_GENERIC_VALUE)
+      if (foo_read(client,FOO_REG_GENERIC) != FOO_GENERIC_VALUE)
          goto ERROR1;
     }
 
@@ -349,7 +348,7 @@ For now, you can ignore the `flags' parameter. It is there for future use.
     /* Determine the chip type. Not needed if a `force_CHIPTYPE' parameter
        was used. */
     if (kind <= 0) {
-      i = foo_read(new_client,FOO_REG_CHIPTYPE);
+      i = foo_read(client,FOO_REG_CHIPTYPE);
       if (i == FOO_TYPE_1) 
         kind = chip1; /* As defined in the enum */
       else if (i == FOO_TYPE_2)
@@ -377,7 +376,7 @@ For now, you can ignore the `flags' parameter. It is there for future use.
     /* SENSORS ONLY END */
 
     /* Fill in the remaining client fields. */
-    strcpy(new_client->name,client_name);
+    strcpy(client->name,client_name);
 
     /* SENSORS ONLY BEGIN */
     data->type = kind;
@@ -389,14 +388,14 @@ For now, you can ignore the `flags' parameter. It is there for future use.
     /* Any other initializations in data must be done here too. */
 
     /* Tell the i2c layer a new client has arrived */
-    if ((err = i2c_attach_client(new_client)))
+    if ((err = i2c_attach_client(client)))
       goto ERROR3;
 
     /* SENSORS ONLY BEGIN */
     /* Register a new directory entry with module sensors. See below for
        the `template' structure. */
-    if ((i = i2c_register_entry(new_client, type_name,
-                                    foo_dir_table_template,THIS_MODULE)) < 0) {
+    if ((i = i2c_register_entry(client, type_name,
+                                foo_dir_table_template,THIS_MODULE)) < 0) {
       err = i;
       goto ERROR4;
     }
@@ -406,14 +405,14 @@ For now, you can ignore the `flags' parameter. It is there for future use.
 
     /* This function can write default values to the client registers, if
        needed. */
-    foo_init_client(new_client);
+    foo_init_client(client);
     return 0;
 
     /* OK, this is not exactly good programming practice, usually. But it is
        very code-efficient in this case. */
 
     ERROR4:
-      i2c_detach_client(new_client);
+      i2c_detach_client(client);
     ERROR3:
     ERROR2:
     /* SENSORS ONLY START */

